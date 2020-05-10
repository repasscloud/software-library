Get-ChildItem -Path '/Users/danijeljames/Developer/software-matrix/lib/scripts/Docker' | Where-Object {$_.Name -notlike 'rancher-compose' } | ForEach-Object { 
    scp $_.FullName rancher@206.189.149.224:/home/rancher/
}

#scp /Users/danijeljames/Developer/software-matrix/lib/scripts/Dockerfile rancher@206.189.149.224:/home/rancher/