rule vba_invoice_downloader
{
    meta:
        author = "Abshir"
        description = "Detects the VBA macro loader found in a phishing document"
    strings:
        $shell       = "Declare PtrSafe Function ShellExecuteA Lib \"shell32.dll\"" ascii wide
        $url         = "Declare PtrSafe Function URLDownloadToFileA Lib \"urlmon\"" ascii wide
        $invoice_url = "http://www.completelysafeandnotmailcious.ru/invoice.exe" ascii wide
        $temp        = "C:\\Appl\\invoice.exe" ascii wide
        $auto        = "Sub Document_Open()" ascii wide
    condition:
        all of ($shell, $url, $invoice_url, $temp, $auto)
}
