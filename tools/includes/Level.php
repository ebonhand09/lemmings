<?php

class Level
{
	private $input_handle;
	private $output_handle;

	public $title;
	public $totalLemmings;
	public $saveLemmings; 
	public $releaseRate; 
	public $playingTime;
	public $maxClimbers;
	public $maxFloaters;
	public $maxBombers; 
	public $maxBlockers;
	public $maxBuilders;
	public $maxBashers; 
	public $maxMiners; 
	public $maxDiggers;
	public $screenStart;
	public $graphicsSet; 
	public $totalObjects;
	public $objectArray; 
	public $totalSteel; 
	public $steelArray; 
	public $totalTerrain;
	public $terrainArray;

	public function import($filename, $format = 'dos')
	{
		$this->input_handle = fopen($filename, 'rb');
		if (! $this->input_handle) die("Error opening $filename.\n");

		$header = fread($this->input_handle, 2048);
		
		$this->releaseRate = ord($header[0x01]);
		$this->totalLemmings = ord($header[0x03]);
		$this->saveLemmings = ord($header[0x05]);
		$this->playingTime = ord($header[0x07]);

		$this->maxClimbers = ord($header[0x09]);
		$this->maxFloaters = ord($header[0x0B]);
		$this->maxBombers = ord($header[0x0D]);
		$this->maxBlockers = ord($header[0x0F]);
		$this->maxBuilders = ord($header[0x11]);
		$this->maxBashers = ord($header[0x13]);
		$this->maxMiners = ord($header[0x15]);
		$this->maxDiggers = ord($header[0x17]);

		$this->screenStart = (ord($header[0x18]) << 8) + ord($header[0x19]);
		$this->graphicsSet = ord($header[0x1B]);

		$this->title = substr($header, 0x7e0, 32);

		// ** Import Objects

		$objectData = substr($header, 0x20, (32 * 8));

		$this->objectArray = array();

		for ($i = 0; $i < 32; $i++)
		{
			$this->objectArray[$i] = new Object;
			$data = substr($objectData, $i * 8, 8);

			$this->objectArray[$i]->import($data);
			if ($this->objectArray[$i]->isEmpty())
			{
				unset($this->objectArray[$i]);
				$this->totalObjects = $i;
				break;
			}
		}

		// ** Import Steel

		$steelData = substr($header, 0x760, (32 * 4));

		$this->steelArray = array();

		for ($i = 0; $i < 32; $i++)
		{
			$this->steelArray[$i] = new Steel;
			$data = substr($steelData, $i * 4, 4);

			$this->steelArray[$i]->import($data);
			if ($this->steelArray[$i]->isEmpty())
			{
				unset($this->steelArray[$i]);
				$this->totalSteel = $i;
				break;
			}
		}
	
		// ** Import Terrain

		$terrainData = substr($header, 0x120, (400 * 4));

		$this->terrainArray = array();

		for ($i = 0; $i < 400; $i++)
		{
			$this->terrainArray[$i] = new Terrain;
			$data = substr($terrainData, $i * 4, 4);

			$this->terrainArray[$i]->import($data);
			if ($this->terrainArray[$i]->isEmpty())
			{
				unset($this->terrainArray[$i]);
				$this->totalTerrain = $i;
				break;
			}
		}
	}

	public function export($filename, $format = 'coco')
	{
		$this->output_handle = fopen($filename, 'wb');
		if (! $this->output_handle) die("Error opening $filename for output.\n");

		fwrite($this->output_handle, sprintf("%32s", $this->title));
		fwrite($this->output_handle, chr($this->releaseRate));
		fwrite($this->output_handle, chr($this->totalLemmings));
		fwrite($this->output_handle, chr($this->saveLemmings));
		fwrite($this->output_handle, chr($this->playingTime));
		fwrite($this->output_handle, chr($this->maxClimbers));
		fwrite($this->output_handle, chr($this->maxFloaters));
		fwrite($this->output_handle, chr($this->maxBombers));
		fwrite($this->output_handle, chr($this->maxBlockers));
		fwrite($this->output_handle, chr($this->maxBuilders));
		fwrite($this->output_handle, chr($this->maxBashers));
		fwrite($this->output_handle, chr($this->maxMiners));
		fwrite($this->output_handle, chr($this->maxDiggers));

		// Start X Position
		fwrite($this->output_handle, chr(self::convertStartXPosition($this->screenStart)));

		fwrite($this->output_handle, chr($this->graphicsSet));
		
		fwrite($this->output_handle, chr($this->totalObjects));

		fwrite($this->output_handle, chr($this->totalSteel));

		$steelOffset = 0x36 + (0x05 * $this->totalObjects);
		fwrite($this->output_handle, Data::convertToWordString($steelOffset)); // Steel Offset - calculate later

		$terrainOffset = $steelOffset + (0x03 * $this->totalSteel);
		fwrite($this->output_handle, Data::convertToWordString($this->totalTerrain));
		fwrite($this->output_handle, Data::convertToWordString($terrainOffset)); // Terrain Offset - calculate later

		foreach ($this->objectArray as $object)
		{
			fwrite($this->output_handle, $object->export());
		}

		foreach ($this->steelArray as $steel)
		{
			fwrite($this->output_handle, $steel->export());
		}

		foreach ($this->terrainArray as $terrain)
		{
			fwrite($this->output_handle, $terrain->export());
		}




	}

	public function convertStartXPosition($startx)
	{
		return ($startx >> 4);
	}
	
}

class Object
{
	const DOS_OVERWRITE = 0x00;
	const DOS_OVERLAY = 0x40;
	const DOS_BEHIND = 0x80;
	const DOS_NORMAL = 0x0F;
	const DOS_UPSIDEDOWN = 0x8F;

	const OVERWRITE = 0x00;
	const OVERLAY = 0x01;
	const BEHIND = 0x02;
	const UPSIDEDOWN = 0x04;
	
	public $id;
	public $x_offset;
	public $y_offset;
	public $drawMode;

	public function import($data)
	{
		$this->x_offset = (ord($data[0]) << 8) + ord($data[1]);

		if ($this->x_offset > 32767) $this->x_offset = 32767 - $this->x_offset;
		$this->x_offset = $this->x_offset - 16;

		$this->y_offset = (ord($data[2]) << 8) + ord($data[3]);
		$this->id = ord($data[5]);
		$this->drawMode = $this->convertDrawMode(ord($data[6]), ord($data[7]));
	}

	public function export()
	{
		$data = '';
		// x offset
		$data .= chr( ($this->x_offset & 0xFF00) >> 8) . chr( $this->x_offset & 0xFF );

		// y offset
		$data .= chr( $this->y_offset );

		// object ID
		$data .= chr( $this->id );

		// draw mode
		$data .= chr( $this->drawMode );
		
		return $data;
	}

	public function convertDrawMode($mode, $orientation)
	{
		$flags = 0;
		if ($mode & self::DOS_OVERLAY == self::DOS_OVERLAY) $flags = $flags + self::OVERLAY;
		if ($mode & self::DOS_BEHIND == self::DOS_BEHIND) $flags = $flags + self::BEHIND;
		if ($orientation == self::DOS_UPSIDEDOWN) $flags = $flags + self::UPSIDEDOWN;

		return $flags;
	}

	public function isEmpty()
	{
		return ( ($this->x_offset == -16 ) && ($this->y_offset == 0) && ($this->id == 0) )
			? true
			: false;
	}
}

class Steel
{
	public $x_offset;
	public $y_offset;
	public $x_area;
	public $y_area;

	public function import($data)
	{
		$this->y_offset = (ord($data[1]) & 0x7F) << 2; // get lower 7 bits
		$this->x_offset = self::extractX((ord($data[0]) << 8) + ord($data[1]));

		$this->x_area = (((ord($data[2]) & 0xF0) >> 4) + 1) * 4;
		$this->y_area = ((ord($data[2]) & 0x0F) + 1) * 4;
	}

	public function export()
	{
		$data = '';
		// x offset
		$xoffs = $this->x_offset + 16;
		$xoffs = $xoffs >> 2; // divide by 4
		$xoffs = $xoffs << 7; // get into place for combining with y value

		$yoffs = $this->y_offset >> 2; // divide by 4
		$xyoffs = $xoffs | $yoffs;
		$data .= Data::convertToWordString($xyoffs);

		// x area and y area
		$x_area = $this->x_area - 4;
		$x_area = $x_area >> 2;
		$x_area = $x_area << 4;

		$y_area = $this->y_area - 4;
		$y_area = $y_area >> 2;
		$xy_area = $x_area | $y_area;

		$data .= chr($xy_area);

		return $data;

	}

	public function extractX($encoded_x)
	{
		$x = ($encoded_x & 0xFF80); // remove Y component
		$negative = ($x > 32767) ? true : false; // if negative, we need to process it later

		$x -= 0x0200;

		if ($negative)
		{ // make it positive, so the shift will work
			$x = 0 - $x;	
		}

		$x = $x >> 5;

		if ($negative)
		{ // undo the 'make it positive'
			$x = 0 - $x;
		}

		return $x;
	}

	public function isEmpty()
	{
		return ( ($this->x_offset == -16 ) && ($this->y_offset == 0) && ($this->x_area == 4) && ($this->y_area ==4) )
			? true
			: false;
	}
}

class Terrain
{
	const DOS_OVERWRITE = 0x00;
	const DOS_NEGATIVE = 0x02;
	const DOS_UPSIDEDOWN = 0x04;
	const DOS_BEHIND = 0x08;

	const OVERWRITE = 0x00;
	const NEGATIVE = 0x01;
	const BEHIND = 0x02;
	const UPSIDEDOWN = 0x04;
	
	public $id; 
	public $x_offset;
	public $y_offset;
	public $drawMode;

	public function import($data)
	{
		$this->drawMode = self::convertDrawMode((ord($data[0]) & 0xF0) >> 4);

		$this->x_offset = self::extractX((ord($data[0]) << 8) + ord($data[1]));
		$this->y_offset = self::extractY((ord($data[2]) << 8) + ord($data[3]));

		$this->id = ord($data[3]) & 0x7F;
	}

	public function export()
	{
		$data = '';

		// Draw mode, X Position
		$drawMode = ($this->drawMode) << 12;
		$xpos = ($this->x_offset + 16) & 0xFFF;
		$combined = $drawMode | $xpos;
		
		$data .= Data::convertToWordString($combined);

		// Y Pos / Terrain ID

		$ypos = ($this->y_offset) << 7;
		$ypos = $ypos + 0x200;
		$id = $this->id;

		$data .= Data::convertToWordString($ypos  | $id);

		return $data;
	}

	public function extractX($encoded_x)
	{
		$x = ($encoded_x & 0x0FFF); // remove drawMode flag component
		$negative = ($x > 32767) ? true : false; // if negative, we need to process it later

		$x -= 0x10;

		return $x;
	}

	public function extractY($encoded_y)
	{
		$y = ($encoded_y & 0xFF80); // remove Y component
		$negative = ($y > 32767) ? true : false; // if negative, we need to process it later

		$y -= 0x0200;

		if ($negative)
		{ // make it positive, so the shift will work
			$y = 0 - $y;	
			$y = $y & 0xFFFF;
		}

		$y = $y >> 7;

		if ($negative)
		{ // undo the 'make it positive'
			$y = 0 - $y;
		}

		return $y;
	}

	public function convertDrawMode($mode)
	{
		$flags = 0;

		if ($mode & self::DOS_NEGATIVE) $flags = $flags + self::NEGATIVE;
		if ($mode & self::DOS_BEHIND) $flags = $flags + self::BEHIND;
		if ($mode & self::DOS_UPSIDEDOWN) $flags = $flags + self::UPSIDEDOWN;

		return $flags;
	}

	public function isEmpty()
	{
		return ( ($this->x_offset == 4079 ) && ($this->y_offset == -5) && ($this->id == 127) && ($this->drawMode == 7) )
			? true
			: false;
	}
}

class Data
{
	public function convertToWordString($value)
	{
		$upper = ($value & 0xFF00) >> 8;
		$lower = ($value & 0xFF);
		return chr($upper) . chr($lower);
	}

	public function convertToNegativeWord($value)
	{	
		$value = $value & 0xFFFF;
		return $value;
	}

}
