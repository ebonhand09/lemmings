#!/usr/bin/env php
<?php

if ($argc < 3) die('insufficient arguments' . PHP_EOL);
$in_level = $argv[1];
$out_level = $argv[2];

	require_once('includes/Level.php');

	$level = new Level;
	$level->import($in_level);

// adjustment code goes here
$adjustment_file = "/home/david/projects/lemmings/resources/terrain-adjustment".$level->graphicsSet.".php";
include $adjustment_file;

foreach($level->terrainArray as $key => $val)
{
	$temp = (isset($adjustment[$level->terrainArray[$key]->id])) ?: 0;
	$level->terrainArray[$key]->x_offset -= $temp;
}

	$level->export($out_level);

