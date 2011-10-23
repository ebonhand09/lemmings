#!/usr/bin/env php
<?php

class OddTable
{
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
	public $position; // this is just a tracking variable

}

/*	this file reads the hard-coded level list below, reads oddtable, reads the pre-converted level files
	and then somehow spits out a look-up table containing:

	Level Sequence Table:
	
	[B start block] [W memory offset] [W data size]	: (5 bytes) this relates to real level data

	[B FF] [W lvltable offset] [W oddtable offset]	: (5 bytes) this relates to clones

	By checking the 'block' byte for an FF, the code can know whether it's a raw level or a cloned level
	and also locate a) the raw level data, and b) the replacement data

	Two different tables are required:
	- level sequence table (format above)
	- oddtable data table 
*/

function convertWordStringToValue($string)
{
	return (ord($string[0]) * 256) + ord($string[1]);
}

// extract oddtable

$oddtable = array();
$map_oddtable_entries = array();

$input_filename = "/home/david/projects/lemmings/resources/dat/oddtable.dat";
$input_handle = fopen($input_filename, 'rb');

if (!$input_handle) die ("Bork - couldn't load $input_filename\n");
$count = 0;
$oldcount = 0;
$emptyentry = null;
do
{
	$entry = fread($input_handle, 0x38);
	if (!$emptyentry) $emptyentry = $entry;
	if ($entry && ($entry != $emptyentry))
	{
		$ot = new OddTable();
		$ot->releaseRate = convertWordStringToValue($entry[0].$entry[1]);
		$ot->totalLemmings = convertWordStringToValue($entry[2].$entry[3]);
		$ot->saveLemmings = convertWordStringToValue($entry[4].$entry[5]);
		$ot->playingTime = convertWordStringToValue($entry[6].$entry[7]);
		$ot->maxClimbers = convertWordStringToValue($entry[8].$entry[9]);
		$ot->maxFloaters = convertWordStringToValue($entry[0x0a].$entry[0x0b]);
		$ot->maxBombers = convertWordStringToValue($entry[0x0c].$entry[0x0d]);
		$ot->maxBlockers = convertWordStringToValue($entry[0x0e].$entry[0x0f]);
		$ot->maxBuilders = convertWordStringToValue($entry[0x10].$entry[0x11]);
		$ot->maxBashers = convertWordStringToValue($entry[0x12].$entry[0x13]);
		$ot->maxMiners = convertWordStringToValue($entry[0x14].$entry[0x15]);
		$ot->maxDiggers = convertWordStringToValue($entry[0x16].$entry[0x17]);
		$ot->title = substr($entry, 0x18, 32);

		$ot->position = $count * 44;

		$oddtable[$count] = $ot;
		$map_oddtable_entries[$oldcount] = $count;
		$count++;
	}
	$oldcount++;
}
while(!feof($input_handle));

$odd_output = NULL;

foreach ($oddtable as $ot)
{
	$odd_output .= $ot->title;
	$odd_output .= chr($ot->releaseRate);
	$odd_output .= chr($ot->totalLemmings);
	$odd_output .= chr($ot->saveLemmings);
	$odd_output .= chr($ot->playingTime);
	$odd_output .= chr($ot->maxClimbers);
	$odd_output .= chr($ot->maxFloaters);
	$odd_output .= chr($ot->maxBombers);
	$odd_output .= chr($ot->maxBlockers);
	$odd_output .= chr($ot->maxBuilders);
	$odd_output .= chr($ot->maxBashers);
	$odd_output .= chr($ot->maxMiners);
	$odd_output .= chr($ot->maxDiggers);
}

file_put_contents('/home/david/projects/lemmings/bin/oddtable.bin', $odd_output); // 44 bytes per entry, total size 1760 bytes


$raw_levels = array();
$level_size = array();
foreach(glob('/home/david/projects/lemmings/bin/levels/*.lvl') as $filename)
{
	$level_size[] = filesize($filename);
}

$levels = array();
$offset_counter = 0;
$block_counter = 0;

foreach ($level_size as $key => $lvlsize)
{
		$tmp = array(
			$block_counter,
			$offset_counter,
			$lvlsize
		);

		$offset_counter += $lvlsize;
		if ($offset_counter > 8192)
		{
			$block_counter++;
			$offset_counter -= 8192;
		}

		$levels[] = $tmp;
}

// create the actual level sequence table
$moe = $map_oddtable_entries;
$level_order = array(
// start block, memory offset, size
// 0xff, lvltable offset, oddtable offset
// comments are: oldentry, real level

0	=> $levels[1],			// Just Dig, Fun 1, 9-1
1	=> array(0xff, 2, $moe[24]),	// Here's One I Prepared Earlier, Tricky 4, 3-0
2	=> $levels[0],			// Every Lemming For Himself, (Raw) 3-0
);

$output = NULL;

foreach ($level_order as $key => $entry)
{
	if ($entry[0] == 0xff)
	{ // entry is an oddtable entry
		$raw = chr(0xff) . chr(0) . chr($entry[1]) . valueToWord($entry[2]);
	}
	else
	{ // entry is a raw level entry
		$raw = chr($entry[0]) . valueToWord($entry[1]) . valueToWord($entry[2]);
	}

	$output .= $raw;
}

file_put_contents('/home/david/projects/lemmings/bin/levelorder.bin', $output);

function valueToWord($value)
{
	$upper = $value >> 8;
	$lower = $value % 256;
	return chr($upper) . chr($lower);
}


