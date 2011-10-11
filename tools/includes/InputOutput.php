<?php

class InputOutput
{

  function readByte($handle)
  {
	$byte = fgetc($handle);
	return ord($byte);
  }

  function readWord($handle, $little_endian = FALSE)
  {
    $first_byte = fgetc($handle);
    $second_byte = fgetc($handle);

	if ($little_endian)
	{
		return (ord($second_byte) * 256) + ord($first_byte);
	}
	else return (ord($first_byte) * 256) + ord($second_byte);
  }

  function readString($handle, $bytes)
  {
    return fread($handle, $bytes);  
  }

  function writeByte($handle, $byte)
  {
	if (!is_numeric($byte)) $byte = ord($byte);
	fwrite($handle, chr($data % 256), 1);
  }

  function writeWord($handle, $word, $little_endian)
  {
	if ($little_endian)
	{
		fwrite($handle, chr(($word & 0xFF00) / 256), 1);
		fwrite($handle, chr(($word % 256)), 1);
	}
	else
	{
		fwrite($handle, chr(($word % 256)), 1);
		fwrite($handle, chr(($word & 0xFF00) / 256), 1);
	}
  }

  function writeString($handle, $bytes, $data)
  {
	if (!is_array($data)) $data = str_split($data);
	foreach ($data as $byte)
	{
		writeByte($handle, $byte);
	}
  }
}
