################
$setHash = '539879409377B761AAD657DC9CD77BF3' #HASH obtido manualmente do arquivo
$setHashAlgorithm = 'MD5'                     #tipo de hash que será usado na comparação
$setFileName = 'arquivo.txt'                  #nome do arquivo que será comparado
$setPath = 'C:\root\caminho'                  #diretório onde começará a procura do arquivo
################

#preenche lista com diretórios onde o arquivo $setFileName foi encontrado     
$paths = @()
$diretorios = Get-ChildItem $setPath -directory
$diretorios | ForEach-Object{
    $paths += "$setPath\$_\$setFileName"
}

#corre toda a lista de diretórios e compara hash obtido de cada arquivo com o original ($setHash)
foreach ($i in $paths ){
    $Hash = Get-FileHash -Algorithm $setHashAlgorithm $i
    $Hash = $Hash.Hash
    if ($Hash -eq $setHash){echo Hash válido!}else{
    echo 'o arquivo encontrado no diretório: '$i' foi MODIFICADO!'
    echo 'saindo com código 2'
    exit 2 #saída com código 2 (CRITICAL)
    }
}
#saída com código 0 (OK)
exit 0
