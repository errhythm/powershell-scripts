Function Get-DirectoryDetails {
    param (
        [string]$path
    )

    Function Get-ChildDetails {
        param (
            [string]$subPath,
            [int]$level = 0
        )

        $indent = " " * ($level * 4)
        $currentDir = Get-Item -Path $subPath
        $items = Get-ChildItem -Path $currentDir.FullName
        $fileCount = $items | Where-Object { -not $_.PSIsContainer } | Measure-Object | Select-Object -ExpandProperty Count
        $dirCount = $items | Where-Object { $_.PSIsContainer } | Measure-Object | Select-Object -ExpandProperty Count
        $typeCounts = ($items | Where-Object { -not $_.PSIsContainer } | Group-Object Extension | ForEach-Object { "$($_.Name)=$($_.Count)" }) -join ", "

        if ($fileCount -gt 0) {
            Write-Output "$indent-- $($currentDir.Name) - $fileCount items ($typeCounts)"
        }
        if ($dirCount -gt 0) {
            Write-Output "$indent-- $($currentDir.Name) - $dirCount directories"
        }

        Get-ChildItem -Path $subPath -Directory | ForEach-Object {
            Get-ChildDetails -subPath $_.FullName -level ($level + 1)
        }
    }

    Get-ChildDetails -subPath $path
}

# Get the current directory
$directoryPath = Get-Location

Write-Output "Directory Details:"
Get-DirectoryDetails -path $directoryPath
