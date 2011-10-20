#!/usr/bin/env php
<?php

function readData($bytes = 1, $handle = NULL)
{
	global $data_file;
	if ($handle === NULL) $handle = $data_file;

	$first_byte = fgetc($handle);
	$second_byte = ($bytes == 2) ? fgetc($handle) : NULL;

	// remember, files are (small-byte) (large-byte)
	return ($second_byte != NULL) 
	  ? (ord($second_byte) * 256) + ord($first_byte)
	  : ord($first_byte);
}

function readString($bytes = 32, $handle = NULL)
{
	global $data_file;
	if ($handle === NULL) $handle = $data_file;

	return fread($handle, $bytes);  
}

function writeData($data, $bytes = 1, $handle = NULL)
{
	global $out_file;
	if ($handle === NULL) $handle = $out_file;

	if ($bytes == 1)
	{
		fwrite($handle, chr($data % 256), 1);
	}
	elseif ($bytes == 2)
	{
		fwrite($handle, chr(($data & 255) / 256), 1);
		fwrite($handle, chr(($data % 256)),1);
	}
}

function writeString($data, $bytes, $handle = NULL)
{
	global $out_file;
	if ($handle === NULL) $handle = $out_file;

	fwrite($handle, $data, $bytes);
}

if ($argc < 2) $argv[1] = 0;
$set = $argv[1];

if ($set == 1)	// purple font
{
	$dat_file = "/home/david/projects/lemmings/resources/dat/main4.dat";
	$number_of_chunks = 94;
	$dat_start_loc = 0x69B0;
	$char_width = 16;
	$stylesheet = 'menu';
	$initial_val = 1;
	$colors = array(
		array(0x00, 0x00, 0x00),
		array(0x00, 0x00, 0x55),
		array(0x00, 0xaa, 0x00),
		array(0xff, 0xff, 0xff),
		array(0x20, 0x08, 0x7f),
		array(0x40, 0x2c, 0x90),
		array(0x68, 0x58, 0xa4),
		array(0x98, 0x8c, 0xbc)
	);
}
else			// green font
{
	$dat_file = "/home/david/projects/lemmings/resources/dat/main6.dat";
	$number_of_chunks = 38;
	$dat_start_loc = 0x1900;
	$char_width = 8;
	$stylesheet = 'terrain0';
	$initial_val = 1;
	$colors = array( // this is wrong - replace when ready
		array(0x00, 0x00, 0x00),
		array(0x00, 0x00, 0x55),
		array(0x00, 0xaa, 0x00),
		array(0xff, 0xff, 0xff),
		array(0x20, 0x08, 0x7f),
		array(0x40, 0x2c, 0x90),
		array(0x68, 0x58, 0xa4),
		array(0x98, 0x8c, 0xbc)
	);
}


$font_handle = fopen($dat_file, 'rb');

// object index starts at 0x00 in $ground_handle
fseek($font_handle, $dat_start_loc);
$chars = array();
for ($char_index = 0; $char_index < $number_of_chunks; $char_index++)
{
	$chars[$char_index] = array();
	$chars[$char_index]['data'] = array_fill(0,16,array_fill(0,$char_width,0));


	//$chars[$char_index]['raw'] = str_split(readString(16, $font_handle));
	$val = $initial_val;
	for ($c = 0; $c < 3; $c++)
	{
		for ($v = 0; $v < 16; $v++)
		{
			$byte = readData(1, $font_handle);

			if (($byte & 0x80)) $chars[$char_index]['data'][$v][0] |= $val;
			if (($byte & 0x40)) $chars[$char_index]['data'][$v][1] |= $val;
			if (($byte & 0x20)) $chars[$char_index]['data'][$v][2] |= $val;
			if (($byte & 0x10)) $chars[$char_index]['data'][$v][3] |= $val;
			if (($byte & 0x08)) $chars[$char_index]['data'][$v][4] |= $val;
			if (($byte & 0x04)) $chars[$char_index]['data'][$v][5] |= $val;
			if (($byte & 0x02)) $chars[$char_index]['data'][$v][6] |= $val;
			if (($byte & 0x01)) $chars[$char_index]['data'][$v][7] |= $val;

			if ($set == 1)
			{
				$byte = readData(1, $font_handle);
				if (($byte & 0x80)) $chars[$char_index]['data'][$v][8] |= $val;
				if (($byte & 0x40)) $chars[$char_index]['data'][$v][9] |= $val;
				if (($byte & 0x20)) $chars[$char_index]['data'][$v][10] |= $val;
				if (($byte & 0x10)) $chars[$char_index]['data'][$v][11] |= $val;
				if (($byte & 0x08)) $chars[$char_index]['data'][$v][12] |= $val;
				if (($byte & 0x04)) $chars[$char_index]['data'][$v][13] |= $val;
				if (($byte & 0x02)) $chars[$char_index]['data'][$v][14] |= $val;
				if (($byte & 0x01)) $chars[$char_index]['data'][$v][15] |= $val;
			}
		}
		$val = $val << 1;
	}
}
/** DRAW **/

for ($index = 0; $index < $number_of_chunks; $index++)
{

	$filename = "/home/david/projects/lemmings/previews/export/font-$set-$index.gif";
	$gif = imagecreate($char_width, 16);
	$background_color = imagecolorallocate($gif, 0, 0, 0);
	$col = array();
	foreach ($colors as $color)
	{
		$col[] = imagecolorallocate($gif, $color[0], $color[1], $color[2]);
	}
	
	$data = $chars[$index]['data'];

	for ($y = 0; $y < 16; $y++)
	{
		for ($x = 0; $x < $char_width; $x++)
		{
			$color = $data[$y][$x];
			$pixel = $col[$color];
			imagesetpixel($gif, $x, $y, $pixel);
		}
	}
	imagegif($gif, $filename);
	unset($gif);
	unset($filename);
	unset($col);
}

echo "Done" . PHP_EOL;
