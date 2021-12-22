$executedCommandCounter = 0

function WriteCommandLineParts ([Array]$parts) {

    Add-Content -Path docu.md -Value "``````log"

    foreach ($part in $parts) {
        Add-Content -Path docu.md -Value $part
    }
    
    Add-Content -Path docu.md -Value "``````"
} 
function WriteGitVersionOutput ($output) {

    Add-Content -Path docu.md -Value "``````json"

    $outputProperties = "SemVer", "FullSemVer", "NuGetVersion"
    # $outputProperties = "*"
    $newOutput = $output | ConvertFrom-Json | Select-Object $outputProperties | ConvertTo-Json
    
    Add-Content -Path docu.md -Value $newOutput
    
    Add-Content -Path docu.md -Value "``````"
} 

$gitCommands = "git init|git add .|git commit -m `"initial commit`"", 
               "git checkout -b develop", 
               "git checkout -b feature/01|touch feature01_1.txt|git add .|git commit -m `"feature01_1`"", 
               "touch feature01_2.txt|git add .|git commit -m `"feature01_2`"", 
               "touch feature01_3.txt|git add .|git commit -m `"feature01_3`"", 
               "git checkout develop|git checkout -b feature/02|touch feature02_1.txt|git add .|git commit -m `"feature02_1`"", 
               "touch feature02_2.txt|git add .|git commit -m `"feature02_2`"", 
               "git checkout develop|git merge feature/01", 
               "git merge feature/02", 
               "git checkout -b release/0.0.1", 
               "touch release0.0.1_1.txt|git add .|git commit -m `"hotfix release0.0.1_1`"", 
               "touch release0.0.1_2.txt|git add .|git commit -m `"hotfix release0.0.1_2`"|git tag v0.0.1",
               "git checkout develop|git merge release/0.0.1", 
               "git checkout master|git merge release/0.0.1", 
               "git checkout develop|git checkout -b feature/03|touch feature03_1.txt|git add .|git commit -m `"feature03_1`"", 
               "touch feature03_2.txt|git add .|git commit -m `"feature03_2`"", 
               "touch feature03_3.txt|git add .|git commit -m `"feature03_3`"", 
               "git checkout develop|git merge feature/03",
               "git checkout -b release/0.0.2", 
               "touch release0.0.2_1.txt|git add .|git commit -m `"hotfix release0.0.2_1`"|git tag v0.0.2",
               "git checkout develop|git merge release/0.0.2", 
               "git checkout master|git merge release/0.0.2"

foreach ($command in $gitCommands) {
	$parts = $command.Split("|")

    foreach ($part in $parts) {
        cmd.exe /c $part
    }

    $executedCommandCounter = $executedCommandCounter + 1

    Add-Content -Path docu.md -Value "# $($executedCommandCounter)"

    WriteCommandLineParts $parts
    
    $output = cmd.exe /c ".\..\gitversion.exe -output json"
    
    WriteGitVersionOutput $output
    Add-Content -Path docu.md -Value "---"
    Add-Content -Path docu.md -Value "`n"
}