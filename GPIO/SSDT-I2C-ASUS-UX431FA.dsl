/*  
    SSDT patch for GPIO Pinning on ELAN1301 trackpad by LeongWZ
    Confirmed working on OpenCore ASUS UX431FA
    
    Compile this .dsl file into .aml file using MaciASL and
    add .aml file into EFI/OC/ACPI folder.
    
    Also, under ACPI->Patch in config.plist,
    add this dict patch below:
    
    (For those using ProperTree, "Find" and "Replace" values found below are in base64
    and have to be converted into hex values; use base64 to hex converters found online)
    ==================================
    <dict>
        <key>Base</key>
		<string></string>
		<key>BaseSkip</key>
		<integer>0</integer>
		<key>Comment</key>
		<string>Rename TPD0._CRS to TPD0.XCRS</string>
		<key>Count</key>
		<integer>0</integer>
		<key>Enabled</key>
		<true/>
		<key>Find</key>
		<data>FCxfQ1JTAA==</data>
		<key>Limit</key>
		<integer>0</integer>
		<key>Mask</key>
		<data></data>
		<key>OemTableId</key>
		<data></data>
		<key>Replace</key>
		<data>FCxYQ1JTAA==</data>
		<key>ReplaceMask</key>
		<data></data>
		<key>Skip</key>
		<integer>0</integer>
		<key>TableLength</key>
		<integer>0</integer>
		<key>TableSignature</key>
		<data></data>
    </dict>
    ==================================
*/

/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200925 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASL55bRL7.aml, Wed Dec 28 00:55:39 2022
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000000B1 (177)
 *     Revision         0x02
 *     Checksum         0xF8
 *     OEM ID           "hack"
 *     OEM Table ID     "TPD0"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20200925 (538970405)
 */

DefinitionBlock ("", "SSDT", 2, "hack", "TPD0", 0x00000000)
{
    External (_SB_.PCI0.I2C0.TPD0, DeviceObj)
    External (_SB_.PCI0.I2C0.TPD0.SBFB, FieldUnitObj)

    Scope (_SB.PCI0.I2C0.TPD0)
    {
        Method (_CRS, 0, Serialized)  // _CRS: Current Resource Settings
        {
            Name (SBFG, ResourceTemplate ()
            {
                GpioInt (Level, ActiveLow, Exclusive, PullUp, 0x0000,
                    "_SB.PCI0.GPI0", 0x00, ResourceConsumer, ,
                    )
                    {   // Pin list
                        0x0023
                    }
            })
            Return (ConcatenateResTemplate (SBFB, SBFG))
        }
    }
}
