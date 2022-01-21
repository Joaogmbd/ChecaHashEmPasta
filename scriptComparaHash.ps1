param($e, $h, $p, $a)
    ################
    #$h                                             #HASH obtido manualmente do arquivo
    #$a                                             #nome do arquivo que será comparado
    #$p                                             #diretório onde começará a procura do arquivo
    #$e                                             #escolhe entre comparar apenas um arquivo ou vários mesmos arquivos a partir de um diretório
    $soma = 0                                       #Soma quantidade total de problemas encontrados durante a execução do código
    $Mensagem = 'Nenhum arquivo foi modificado.'    #Mensagem que retornará junto com o código de sáida
    ################

if ($e -eq 'path'){ 
    #preenche lista com diretórios onde o arquivo $a foi encontrado     
    $paths = @()
    $diretorios = Get-ChildItem $p -directory
    $diretorios | ForEach-Object{
        $paths += "$p\$_\$a"
    }
    $pathModificado = @()
    #corre toda a lista de diretórios e compara hash obtido de cada arquivo com o original ($h
    foreach ($i in $paths ){
        $Hash = Get-FileHash $i -Algorithm MD5
        $Hash = $Hash.Hash
        if ($Hash -eq $h){
            echo 'Hash válido!'
        }else{
            echo 'hash inválido!'
            $soma += 1
            $pathModificado += $i
        }
    }
    #exibe mensagem e realiza o retorno do script
    if($soma -gt 0){
        $Mensagem = 'Foram encontrados '+$soma+' arquivos modificados nos diretórios: '+ $pathModificado
        echo $Mensagem
        exit 2
    }elseif($soma -eq 0){
        echo $Mensagem
        exit 0
    }
#Comparação de hash de apenas um arquivo
}elseif($e -eq 'file'){
  $Hash = Get-FileHash "$p\$a" -Algorithm MD5
  $Hash = $Hash.Hash
  if ($Hash -eq $h){
  #exibe mensagem e realiza o retorno do script
        echo "hash válido no local"
        exit 0
        }else{
        echo 'Hash invalido'
        exit 2
        }
#quando o script recebe algum parametro errado, a mensagem a seguir é exibida
}else{
    echo "Escolha uma opção válida!"
}
