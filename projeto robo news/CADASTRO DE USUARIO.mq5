input string nome; // NOME DO USUARIO
input datetime dataValidade; //DATA DE VALIDADE
input double conta; // NUMERO DA CONTA
string codigo,instrucao2;
int arquivo,instrucao;

bool t1 = false,t2 = false,t3 = false;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {

   if(nome == NULL)
     {
      Alert("NOME DE USUARIO NÃO FOI DEFINIDO !");

     }
   else
     {
      t1 = true;
     }

   if(dataValidade == NULL)
     {
      Alert("DATA DE VALIDADE NÃO FOI DEFINIDO !");

     }
   else
     {
      t2 = true;
     }
   if(conta == NULL)
     {
      Alert("NUMERO DA CONTA NÃO FOI DEFINIDO !");

     }
   else
     {
      t3 = true;
     }
   if(t1 == true && t2 == true && t3 == true)
     {
      codigo = "daljfasdfkxm432xtyn34r7y4m230ru4d2038drn8u24tyf2564y8rs0ukuEADFGADSJFGADSIFHNEWIANRXMOIEUMQWOSIEW,PIHMimhisdfhdglkjfdhgfdymgsoidfgmigy8w4sergsd626sedfjdsgkj5347n0r8ueishadfjkgdsfnsdu9edry74tcycn584u20ktq3syirny4x7324yrb2c93rxyn9|"+dataValidade+"|324drhrehfgwryfgweruifgweirfgnwrefirefygrefuywgefuyyrfwnrefowimfume9mr435yn345y3jt8345t8kefw9d8fj9w885t5kt983jty45tj9f78j945ykferjigjmngdcng|"+conta+"|78y58jf3k4yjen7n8fryj987rd4j7854jyd98jr7yr987ggjyd98yjfw7854ycnf7cyf958cj7yfn5987fy8j4wrynf59f7y4w98fyc9c75wyfn975fcyn957fn9wf4ywn9yrw4yf8ycfj845yfn9w5yxc4cru24hr4nury42324y3nidy4rbndruyn423idru4ynrdiuy42ru4dnrdnc2tx349|"+nome;
      instrucao2 = "1. PASSO \n \n ENVIE O ROBO MAIS A LICENÇA QUE FOI GERADO PARA VOCE NESSA PASTA \n \n 2. PASSO \n \n PEÇA PARA O CLIENTE ADICIONAR O ROBO NO GRAFICO ATE APARECER A FRASE(ADICIONE A LICENÇA NO ENDEREÇO DA PASTA ABAIXO !) \n \n 3.PASSO \n \n PEÇA PARA ELE ADICIONAR A LICENÇA QUE VOCE MANDOU NA PASTA INDICADA ! \n \n";
      arquivo = FileOpen("licença.txt",FILE_COMMON|FILE_TXT|FILE_WRITE);
      FileWriteString(arquivo,codigo);
      FileClose(arquivo);
      if(FileIsExist("INSTRUÇÃO.txt",FILE_COMMON))
        {

        }
      else
        {
         int condicao = MessageBox("DESEJA BAIXAR AS INSTRUÇÕES?",NULL,MB_YESNO);
         if(condicao == 6)
           {
            instrucao = FileOpen("INSTRUÇÃO.txt",FILE_COMMON|FILE_TXT|FILE_WRITE);
            FileWriteString(instrucao,instrucao2);
            FileClose(instrucao);
           }

        }
      MessageBox("CADASTRO REALIZADO COM SUCESSO !");
      Alert("COPIE O ENDEREÇO ABAIXO E COLE NA  AREA DAS PASTAS ! \n \n"+TerminalInfoString(TERMINAL_COMMONDATA_PATH)+"\Files");

      ExpertRemove();
     }




// int teste = MessageBox("lalla",NULL,MB_YESNO);
// Print(teste);




   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {


  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {


  }

//+------------------------------------------------------------------+
