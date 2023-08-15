# Define the file path and import the CSV data
$file = "C:\Users\xxxx\Desktop\ADPRPSFTPADUNDPORTVBB4MPRiskmanagementterms.07232023160737.csv"
$adpfile = Import-Csv -Path $file -Delimiter ","

# Select the desired columns and export the filtered data to a new CSV file
$searchterm = "X3 Access"
$filteredData = $adpfile | Where-Object { $_."Description - Company Property Info" -match $searchterm } | 
               Select-Object "Empl ID", "Name - Personal Dta", "Description - Company Property Info"

$filteredData | Export-Csv -Path "C:\Users\hussains\Desktop\file1.csv" -NoTypeInformation

# Check if there are results to send via email
if ($filteredData.Count -gt 0) {
    Send-MailMessage -Attachments "C:\Users\hussains\Desktop\file1.csv" `
                     -SmtpServer "smtpxxxx" `
                     -To "xxxxx" `
                     -From "xxxxxxx" `
                     -Subject "Test" `
                     -Body "Hello, Please find the filtered data in the attached CSV file."
}
