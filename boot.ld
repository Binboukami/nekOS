ENTRY(_start)
OUTPUT_FORMAT(binary)

SECTIONS
{
	. = 0x7C00;
	.boot_init : AT(0x7C00) ALIGN(4)
	{

	}

	. = 0x7DFE;
	.boot_signt : AT(0X7DFE) { }

	. = 0x1000;
	.kernel_entry : AT(0x1000)
	{

	}
}
