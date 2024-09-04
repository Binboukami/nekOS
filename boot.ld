ENTRY(_start)
OUTPUT_FORMAT(binary)

SECTIONS
{
	. = 0x7C00;
	.boot_init : AT(0x7C00) ALIGN(4)
	{

	}

	. = 0x7DFE;
	.boot_signt : { }

	. = 0x7E00;
	.boot_load : AT(0x7E00) ALIGN(4)
	{

	}
}
