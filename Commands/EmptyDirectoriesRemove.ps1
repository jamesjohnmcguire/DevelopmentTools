Get-ChildItem -Directory -Recurse | 
	Sort-Object FullName -Descending | 
	Where-Object { $_.GetFiles().Count -eq 0 -and $_.GetDirectories().Count -eq 0 } | 
	Remove-Item -Force -ErrorAction SilentlyContinue
