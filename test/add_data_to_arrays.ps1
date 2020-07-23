# Create blank array for data to be returned
#[Array]$function_return_array=@()

# Create ArrayList of languages
#[System.Collections.ArrayList]$langList=@()
#foreach($i in $Languages) {
#    $langList.Add($i)
#}

# Add data to return array
#$function_return_array += $json_data_return
[System.Console]::Clear()


[System.Collections.ArrayList]$ArrayList=@()

$ArrayList.Add('Persia') | Out-Null
$ArrayList.Add('Croatia') | Out-Null
$ArrayList.Add('Germany') | Out-Null
$ArrayList
$ArrayList.Add('Paradisia') | Out-Null
$ArrayList.RemoveAt(2)
$ArrayList