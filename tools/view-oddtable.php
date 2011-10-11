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

}

$input_filename = "../resources/dat/oddtable.dat";
$input_handle = fopen($input_filename, 'rb');

if (!$input_handle) die ("Bork - couldn't load $input_filename\n");
$count = 0;
$emptyentry = null;
do
{
	$entry = fread($input_handle, 0x38);
	if (!$emptyentry) $emptyentry = $entry;
	if ($entry && ($entry != $emptyentry))
	{
		var_dump($entry);
		$count++;
	}
}
while(!feof($input_handle));
echo "\nFinal Count: $count\n";
