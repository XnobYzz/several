$width = [console]::WindowWidth
$height = [console]::WindowHeight
$text = "XIE DEPCHAI :D"
$x = [math]::Floor(($width - $text.Length) / 2)
$y = [math]::Floor($height / 2)
$exitMessage = "Press Enter to exit"
$exitX = [math]::Floor(($width - $exitMessage.Length) / 2)
$exitY = $y + 1
$finalMessage = "Hi XIE, have a nice day!"

function Show-RainbowText {
    param (
        [string]$text,
        [int]$x,
        [int]$y
    )
    $colors = @('Red', 'Yellow', 'Green', 'Cyan', 'Blue', 'Magenta')
    while ($true) {
        foreach ($color in $colors) {
            [console]::SetCursorPosition($x, $y)
            Write-Host $text -ForegroundColor $color
            [console]::SetCursorPosition($exitX, $exitY)
            Write-Host $exitMessage -ForegroundColor 'Gray'
            if ($host.UI.RawUI.KeyAvailable -and ($host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')).VirtualKeyCode -eq 13) {
                [console]::Clear()
                [console]::SetCursorPosition($finalX, $finalY)
                Write-Host $finalMessage -ForegroundColor 'Red'
                return
            }
            Start-Sleep -Milliseconds 200
        }
    }
}

Show-RainbowText -text $text -x $x -y $y
