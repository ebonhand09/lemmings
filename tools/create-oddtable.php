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

0	=> $levels[(9*8)+1],
1	=> $levels[(9*8)+5],
2	=> $levels[(9*8)+6],
3	=> $levels[(9*8)+2],
4	=> $levels[(9*8)+3],
5	=> $levels[(9*8)+4],
6	=> $levels[(9*8)+7],
7	=> array(0xff, 51, $moe[6]), //  6, 0-6
8	=> array(0xff, 43, $moe[10]), // 10, 1-2
9	=> array(0xff, 68, $moe[26]), // 26, 3-2
10	=> array(0xff, 77, $moe[34]), // 34, 4-2
11	=> array(0xff, 52, $moe[7]), //  7, 0-7
12	=> $levels[(1*8)+6],
13	=> array(0xff, 59, $moe[15]), // 15, 1-7
14	=> array(0xff, 60, $moe[18]), // 18, 2-2
15	=> array(0xff, 62, $moe[20]), // 20, 2-4
16	=> array(0xff, 65, $moe[23]), // 23, 2-7
17	=> array(0xff, 78, $moe[35]), // 35, 4-3
18	=> array(0xff, 84, $moe[41]), // 41, 5-1
19	=> array(0xff, 96, $moe[51]), // 51, 6-3
20	=> array(0xff, 115, $moe[68]), // 68, 8-4
21	=> $levels[(1*8)+3],
22	=> array(0xff, 76, $moe[33]), // 33, 4-1
23	=> array(0xff, 92, $moe[47]), // 47, 5-7
24	=> array(0xff, 93, $moe[48]), // 48, 6-0
25	=> array(0xff, 102, $moe[57]), // 57, 7-1
26	=> array(0xff, 81, $moe[38]), // 38, 4-6
27	=> array(0xff, 94, $moe[49]), // 49, 6-1
28	=> array(0xff, 98, $moe[53]), // 53, 6-5
29	=> array(0xff, 113, $moe[66]), // 66, 8-2
// end fun, start tricky
30	=> $levels[(0*8)+0],
31	=> array(0xff, 12, $moe[14]), // 14, 1-6
32	=> array(0xff, 88, $moe[17]), // 17, 2-1
33	=> array(0xff, 66, $moe[24]), // 24, 3-0
34	=> array(0xff, 67, $moe[25]), // 25, 3-1
35	=> array(0xff, 69, $moe[27]), // 27, 3-3
36	=> array(0xff, 70, $moe[28]), // 28, 3-4
37	=> array(0xff, 82, $moe[39]), // 39, 4-7
38	=> array(0xff, 95, $moe[50]), // 50, 6-2
39	=> array(0xff, 104, $moe[59]), // 59, 7-3
40	=> array(0xff, 108, $moe[63]), // 63, 7-7
41	=> array(0xff, 110, $moe[64]), // 64, 8-0
42	=> array(0xff, 114, $moe[67]), // 67, 8-3
43	=> $levels[(0*8)+2],
44	=> array(0xff, 0, $moe[73]), // 73, 9-1
45	=> array(0xff, 4, $moe[75]), // 75, 9-3
46	=> array(0xff, 5, $moe[76]), // 76, 9-4
47	=> array(0xff, 1, $moe[77]), // 77, 9-5
48	=> array(0xff, 6, $moe[79]), // 79, 9-7
49	=> $levels[(0*8)+3],
50	=> $levels[(0*8)+5],
51	=> $levels[(0*8)+6],
52	=> $levels[(0*8)+7],
53	=> $levels[(1*8)+0],
54	=> $levels[(1*8)+1],
55	=> $levels[(1*8)+2],
56	=> $levels[(1*8)+4],
57	=> $levels[(1*8)+5],
58	=> $levels[(2*8)+0],
59	=> $levels[(1*8)+7],
// end tricky, start taxing
60	=> $levels[(2*8)+2],
61	=> $levels[(2*8)+3],
62	=> $levels[(2*8)+4],
63	=> $levels[(2*8)+5],
64	=> $levels[(2*8)+6],
65	=> $levels[(2*8)+7],
66	=> $levels[(3*8)+0],
67	=> $levels[(3*8)+1],
68	=> $levels[(3*8)+2],
69	=> $levels[(3*8)+3],
70	=> $levels[(3*8)+4],
71	=> $levels[(3*8)+5],
72	=> $levels[(3*8)+6],
73	=> $levels[(3*8)+7],
74	=> $levels[(0*8)+1],
75	=> $levels[(4*8)+0],
76	=> $levels[(4*8)+1],
77	=> $levels[(4*8)+2],
78	=> $levels[(4*8)+3],
79	=> $levels[(4*8)+4],
80	=> $levels[(4*8)+5],
81	=> $levels[(4*8)+6],
82	=> $levels[(4*8)+7],
83	=> $levels[(5*8)+0],
84	=> $levels[(5*8)+1],
85	=> $levels[(5*8)+2],
86	=> $levels[(5*8)+3],
87	=> $levels[(5*8)+4],
88	=> $levels[(2*8)+1],
89	=> $levels[(6*8)+7],
// end taxing, start mayhem
90	=> $levels[(5*8)+5],
91	=> $levels[(5*8)+6],
92	=> $levels[(5*8)+7],
93	=> $levels[(6*8)+0],
94	=> $levels[(6*8)+1],
95	=> $levels[(6*8)+2],
96	=> $levels[(6*8)+3],
97	=> $levels[(6*8)+4],
98	=> $levels[(6*8)+5],
99	=> $levels[(6*8)+6],
100	=> array(0xff, 89, $moe[55]), // 55, 6-7
101	=> $levels[(7*8)+0],
102	=> $levels[(7*8)+1],
103	=> $levels[(7*8)+2],
104	=> $levels[(7*8)+3],
105	=> $levels[(7*8)+4],
106	=> $levels[(7*8)+5],
107	=> $levels[(7*8)+6],
108	=> $levels[(7*8)+7],
109	=> array(0xff, 3, $moe[74]), // 74, 9-2
110	=> $levels[(8*8)+0],
111	=> $levels[(0*8)+4],
112	=> $levels[(8*8)+1],
113	=> $levels[(8*8)+2],
114	=> $levels[(8*8)+3],
115	=> $levels[(8*8)+4],
116	=> $levels[(8*8)+5],
117	=> $levels[(8*8)+6],
118	=> $levels[(8*8)+7],
119	=> $levels[(9*8)+0],

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


