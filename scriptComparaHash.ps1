param($e, $h, $p, $a)
    ################
    #$h                                             #HASH obtido manualmente do arquivo
    #$a                                             #nome do arquivo que será comparado
    #$p                                             #diretório onde começará a procura do arquivo
    #$e                                             #escolhe entre comparar apenas um arquivo ou vários mesmos arquivos a partir de um diretório
    $soma = 0                                       #Soma quantidade total de problemas encontrados durante a execução do código
    $Mensagem = 'Nenhum arquivo foi modificado.'    #Mensagem que retornará junto com o código de sáida
    $exit = 0
    ################

if ($e -eq 'path'){ 
    #preenche lista com diretórios onde o arquivo $a foi encontrado     
    $paths = @()
    $diretorios = Get-ChildItem $p -directory
    $diretorios | ForEach-Object{
        $paths += "$p\$_\$a"
    }
    $pathModificado = @()
    #corre toda a lista de diretórios e compara hash obtido de cada arquivo com o original
    foreach ($i in $paths ){
            #Verifica a existencia do arquivo
            $check = Test-Path -Path $i -PathType Leaf
            if($check -eq 0){
                #criando o arquivo
                New-Item -Path $i -ItemType "file" -Value "Arquivo de segurança para monitoramento de alterações" > $null
            }

        $Hash = (Get-FileHash $i -Algorithm MD5 -ErrorAction SilentlyContinue).Hash
        if ($Hash -eq $h){
        }else{
            $timestamp = (Get-Item "$i" -ErrorAction SilentlyContinue).LastWriteTime   #Recebe informacao de quando foi alterado o arquivo
            $soma += 1
            $pathModificado += "$i as $timestamp`n"
        }
    }
    #exibe mensagem e realiza o retorno do script
    if($soma -gt 0){
        $Mensagem = "Foram encontrados $soma arquivos modificados nos diretorios:`n $pathModificado"
        $exit = 2
    }
    echo $Mensagem
    exit $exit
#Comparação de hash de apenas um arquivo
}
elseif($e -eq 'file'){

    $c =  "$p\$a"
    echo $caminho
    $check = Test-Path -Path $c -PathType Leaf

    if($check -eq 0){
    echo "O arquivo nao existe"
    exit 3
    }

    $Hash = (Get-FileHash $c -Algorithm MD5).Hash

    $timestamp = (Get-Item $c).LastWriteTime   #Recebe horário exato em que foi executado o script
    if ($Hash -eq $h){
    #exibe mensagem e realiza o retorno do script
        $Mensagem = "hash valido no local: $c"
        $exit = 0
        }else{
        $Mensagem = "O arquivo foi MODIFICADO no local: $c as $timestamp"
        $exit = 2
        }
        echo $Mensagem
        exit $exit
#quando o script recebe algum parametro errado, a mensagem a seguir é exibida
}else{
    echo "Erro na definicao de parametros, verifique-os novamente."
    exit 3
}
