String nome = "Joana";
String dataNascimento = "06/12/2003";
String localNascimento = "Alges";
String pessoaImportante = "Afonso";
String lugarSignificativo = "32.6471, -16.9026";
String dataMarcante = "01/07/2021";

ArrayList<String> instrucoes = new ArrayList<String>();
ArrayList<String> planoZonas = new ArrayList<String>();
int passoAtual = 0;

int valorNome;
int valorPessoa;
int numeroCarreiras;
int[] sequenciaPuxadinhos;

String corTafta;
int regraCorBase;

float latitude;
float longitude;

int numeroZonasPuxadinhos;
int numeroZonasTafta;

boolean mostrarResumo = true;

void setup() {
  size(900, 600);
  textFont(createFont("Arial", 22));
  gerarInstrucoes();
}

void draw() {

  background(250);

  if (mostrarResumo) {

    desenharResumo();

  } else {

    fill(30);

    textAlign(CENTER);

    textSize(26);
    text("Sistema de Instruções", width/2, 50);

    textSize(18);
    text("Passo " + (passoAtual+1) + " / " + instrucoes.size(),
         width/2, 90);

    stroke(180);
    line(120,120,width-120,120);

    fill(0);

    textSize(30);
    text(instrucoes.get(passoAtual),
         width/2,
         height/2);

    textSize(16);

    fill(120);

    text("SPACE = próximo | ← = anterior",
         width/2,
         height-40);
  }
}

void keyPressed() {
  if (key == ' ') {
    if (mostrarResumo) {
      mostrarResumo = false;
    } else if (passoAtual < instrucoes.size()-1) {
      passoAtual++;
    }
  }
  if (!mostrarResumo && keyCode == LEFT) {

    if (passoAtual > 0) {
      passoAtual--;
    }
  }
}


void gerarInstrucoes() {
  instrucoes.clear();
  // Converte os dados pessoais em parâmetros
  converterDados();
  // Gera a sequência dos puxadinhos
  gerarSequenciaSimetrica();
  // Gera a ordem das zonas (P e T)
  gerarPlanoZonas();
  // Bainha inicial
  adicionarBainha();
  // A bainha nunca é seguida diretamente por uma zona
  adicionarTecidoBase(distanciaEntreZonas());
  // Percorre o plano gerado
  for (String zona : planoZonas) {
    if (zona.equals("P")) {
      adicionarZonaPuxadinhos();
    }
    if (zona.equals("T")) {
      adicionarZonaTafta();
    }
    // Entre todas as zonas existe sempre tecido base
    adicionarTecidoBase(distanciaEntreZonas());
  }
  // Bainha final
  adicionarBainha();
}


void gerarPlanoZonas() {
  planoZonas.clear();
  int p = numeroZonasPuxadinhos;
  int t = numeroZonasTafta;
  if (t >= p) {
    while (t > 0 || p > 0) {
      if (t > 0) {
        planoZonas.add("T");
        t--;
      }
      if (p > 0) {
        planoZonas.add("P");
        p--;
      }

      if (t > p && t > 0) {
        planoZonas.add("T");
        t--;
      }
    }
  } else {
    while (p > 0 || t > 0) {
      if (p > 0) {
        planoZonas.add("P");
        p--;
      }
      if (t > 0) {
        planoZonas.add("T");
        t--;
      }
      if (p > t && p > 0) {
        planoZonas.add("P");
        p--;
      }
    }
  }
  println("Plano das zonas:");
  println(planoZonas);
}


// CONVERTE OS DADOS PESSOAIS EM PARÂMETROS DA TECELAGEM
void converterDados() {

  valorNome = calcularValor(nome);
  valorPessoa = calcularValor(pessoaImportante);

  int opcao = valorPessoa % 3;

  if (opcao==0) numeroCarreiras=3;
  if (opcao==1) numeroCarreiras=5;
  if (opcao==2) numeroCarreiras=7;

  lerCoordenadas();
  corTafta = escolherCorTafta();
  regraCorBase = escolherRegraCorBase();

  numeroZonasPuxadinhos =
    calcularNumeroZonasPuxadinhos();

  numeroZonasTafta =
    calcularNumeroZonasTafta();

  println("nº de Puxadinhos = " + numeroZonasPuxadinhos);
  println("nº de Tafetá = " + numeroZonasTafta);
}


// CONVERTE UM TEXTO NUM VALOR NUMÉRICO
int calcularValor(String texto) {
  texto = texto.toUpperCase();
  int soma=0;
  for (int i=0; i<texto.length(); i++) {
    char c=texto.charAt(i);
    if (c>='A' && c<='Z') {
      soma+=(c-64);
    }
  }
  return soma;
}


// ARREDONDA PARA MÚLTIPLOS DE 0.1 cm
float arredondar(float valor, float passo) {
  return round(valor / passo) * passo;
}


// LÊ AS COORDENADAS DO LUGAR SIGNIFICATIVO
void lerCoordenadas() {
  String[] p = split(lugarSignificativo, ',');
  latitude = float(p[0]);
  longitude = float(p[1]);
}


// CALCULA O NÚMERO DE ZONAS DE PUXADINHOS
int calcularNumeroZonasPuxadinhos() {
  int valor = int(abs(latitude * 10000));
  return (valor % 3) + 2;
}


// CALCULA O NÚMERO DE ZONAS DE TAFETÁ
int calcularNumeroZonasTafta() {
  int valor = int(abs(longitude * 10000));
  int maximo = int(10 / comprimentoZonaTafta());

  println("Comprimento zona Tafeta = " + comprimentoZonaTafta());
  //println("Maximo = " + maximo);
  //println("Valor = " + valor);
  //println("Resultado = " + ((valor % (maximo-1)) + 2));
  maximo = constrain(maximo, 2, 10);
  return (valor % (maximo-1)) + 2;
}


// GERA A SEQUÊNCIA DOS PUXADINHOS (Padrão Arroz Doce)
void gerarSequenciaSimetrica() {

  // Valor base entre 10 e 20
  int base = (valorNome % 11) + 10;
  sequenciaPuxadinhos = new int[numeroCarreiras];
  for (int i = 0; i < numeroCarreiras; i++) {
    // Primeira e última carreira
    if (i == 0 || i == numeroCarreiras - 1) {
      sequenciaPuxadinhos[i] = base;
    }
    // Carreiras intermédias
    else {
      sequenciaPuxadinhos[i] = base * 2;
    }
  }
}


// DISTÂNCIA ENTRE ZONAS (1 a 5 cm)
float distanciaEntreZonas() {
  String[] p = split(dataNascimento, '/');
  int dia = int(p[0]);
  int mes = int(p[1]);
  // Soma do dia e do mês
  int soma = dia + mes;
  // Mapeia a soma para um valor entre 1 e 5 cm
  return arredondar(
    map(soma, 2, 43, 1.0, 5.0),
    0.1
    );
}


// COMPRIMENTO TOTAL DA ZONA DE TAFETÁ
float comprimentoZonaTafta() {
  String[] p = split(dataMarcante, '/');
  int ano = int(p[2]);
  int ultimos = ano % 100;
  if (ultimos <= 19) return 2.0;
  if (ultimos <= 39) return 2.5;
  if (ultimos <= 59) return 3.0;
  if (ultimos <= 79) return 3.5;
  if (ultimos <= 89) return 4.0;
  if (ultimos <= 94) return 4.5;
  return 5.0;
}


// COMPRIMENTO DOS SEGMENTOS DE TAFETÁ
float comprimentoSegmentoTafta() {
  String[] p = split(dataMarcante, '/');
  int dia = int(p[0]);
  if (dia<=4) return 0.2;
  if (dia<=8) return 0.3;
  if (dia<=12) return 0.4;
  if (dia<=16) return 0.5;
  if (dia<=20) return 0.6;
  if (dia<=24) return 0.7;
  if (dia<=27) return 0.8;
  if (dia<=29) return 0.9;
  return 1.0;
}


// COMPRIMENTO DOS SEGMENTOS DE TECIDO BASE
float comprimentoSegmentoBase() {
  String[] p = split(dataMarcante, '/');
  int mes = int(p[1]);
  float tafta = comprimentoSegmentoTafta();
  switch(mes) {
  case 1:
    return tafta + 0.2;
  case 2:
    return tafta + 0.3;
  case 3:
    return tafta + 0.4;
  case 4:
    return tafta + 0.5;
  case 5:
    return tafta + 0.6;
  case 6:
    return tafta + 0.7;
  case 7:
    return tafta + 0.2;
  case 8:
    return tafta + 0.3;
  case 9:
    return tafta + 0.4;
  case 10:
    return tafta + 0.5;
  case 11:
    return tafta + 0.6;
  case 12:
    return tafta + 0.7;
  }
  return tafta + 0.2;
}


// ESCOLHE A COR DO TAFETÁ
String escolherCorTafta() {

  String[] cores = {
    "vermelho",
    "azul",
    "verde",
    "amarelo",
    "laranja",
    "roxo"
  };
  int valor = int(abs(latitude * 10000) * 31 + abs(longitude * 10000));
  int indice = valor % cores.length;
  return cores[indice];
}

int escolherRegraCorBase() {
  int valor = calcularValor(localNascimento);
  return valor % 5;
}


void desenharResumo() {
  textAlign(CENTER);
  fill(0);
  textSize(28);
  text("Resumo do tecido", width/2, 60);

  // quadrado da cor
  fill(corProcessing(corTafta));
  rectMode(CENTER);
  rect(width/2, 130, 70, 70);
  fill(0);
  textSize(18);
  text("Cor do tafetá: " + corTafta,
       width/2, 210);
  text("Zonas de puxadinhos: "
       + numeroZonasPuxadinhos,
       width/2, 250);
  text("Zonas de tafetá: "
       + numeroZonasTafta,
       width/2, 290);

  String ordem = "";
  for (String z : planoZonas) {
    ordem += z + " ";
  }
  text("Ordem das zonas:",
       width/2, 340);
  text(ordem,
       width/2, 370);
  fill(120);
  text("SPACE para começar",
       width/2,
       height-40);
}


color corProcessing(String cor) {

  if (cor.equals("vermelho"))
    return color(220, 50, 50);

  if (cor.equals("azul"))
    return color(60, 90, 220);

  if (cor.equals("verde"))
    return color(60, 170, 80);

  if (cor.equals("amarelo"))
    return color(245, 220, 60);

  if (cor.equals("laranja"))
    return color(255, 140, 0);

  if (cor.equals("roxo"))
    return color(140, 80, 180);

  return color(200);
}


// ADICIONA A BAINHA
void adicionarBainha() {
  instrucoes.add("Tecer 3,0 cm de bainha");
}


// ADICIONA UMA ZONA DE TECIDO BASE
void adicionarTecidoBase(float cm) {
  float corCm = arredondar(cm * 0.25, 0.1);
  float branco = arredondar(cm - corCm, 0.1);
  switch(regraCorBase) {

    // totalmente branco
  case 0:
    instrucoes.add(
      "Tecer "
      + nf(cm, 0, 1)
      + " cm de tecido base (branco)"
      );
    break;

    // totalmente colorido
  case 1:
    instrucoes.add(
      "Tecer "
      + nf(cm, 0, 1)
      + " cm de tecido base ("+corTafta+")"
      );
    break;

    // cor no início
  case 2:
    instrucoes.add(
      "Tecer "
      + nf(corCm, 0, 1)
      + " cm de tecido base ("+corTafta+")"
      );
    instrucoes.add(
      "Tecer "
      + nf(branco, 0, 1)
      + " cm de tecido base (branco)"
      );
    break;

    // cor no centro
  case 3:
    float lado = branco/2.0;
    instrucoes.add(
      "Tecer "
      + nf(lado, 0, 1)
      + " cm de tecido base (branco)"
      );
    instrucoes.add(
      "Tecer "
      + nf(corCm, 0, 1)
      + " cm de tecido base ("+corTafta+")"
      );
    instrucoes.add(
      "Tecer "
      + nf(lado, 0, 1)
      + " cm de tecido base (branco)"
      );
    break;

    // cor no fim
  case 4:
    instrucoes.add(
      "Tecer "
      + nf(branco, 0, 1)
      + " cm de tecido base (branco)"
      );
    instrucoes.add(
      "Tecer "
      + nf(corCm, 0, 1)
      + " cm de tecido base ("+corTafta+")"
      );
    break;
  }
}


// GERA UMA ZONA COMPLETA DE TAFETÁ
void adicionarZonaTafta() {
  float comprimentoZona = comprimentoZonaTafta();
  float tafta = comprimentoSegmentoTafta();
  float base = comprimentoSegmentoBase();

  float total = 0;
  boolean primeiraInstrucao = true;

  while (total < comprimentoZona) {
    float restante = comprimentoZona - total;

    // Se já não cabe um ciclo completo (tafetá + base + tafetá),
    // o último tafetá ocupa todo o espaço restante.
    if (restante <= tafta + base) {

      if (primeiraInstrucao) {
        instrucoes.add(
          "Zona de tafetá\n" +
          "Tecer " + nf(restante, 0, 1) +
          " cm de tafetá (" + corTafta + ")"
          );
      } else {
        instrucoes.add(
          "Tecer " + nf(restante, 0, 1) +
          " cm de tafetá (" + corTafta + ")"
          );
      }
      total += restante;
      break;
    }

    // Segmento normal de tafetá
    if (primeiraInstrucao) {
      instrucoes.add(
        "Zona de tafetá\n" +
        "Tecer " + nf(tafta, 0, 1) +
        " cm de tafetá (" + corTafta + ")"
        );
      primeiraInstrucao = false;
    } else {
      instrucoes.add(
        "Tecer " + nf(tafta, 0, 1) +
        " cm de tafetá (" + corTafta + ")"
        );
    }
    total += tafta;

    // Segmento de tecido base
    instrucoes.add(
      "Tecer " + nf(base, 0, 1) +
      " cm de tecido base (branco)"
      );

    total += base;
  }
}


// GERA UMA ZONA DE PUXADINHOS
void adicionarZonaPuxadinhos() {
  for (int i=0; i<sequenciaPuxadinhos.length; i++) {

    // Na primeira carreira junta o título e a carreira
    if (i == 0) {
      instrucoes.add(
        "Zona de puxadinhos\n" +
        "Carreira " + (i+1) + " de " + numeroCarreiras
        );
    } else {
      instrucoes.add(
        "Carreira " + (i+1) + " de " + numeroCarreiras
        );
    }
    instrucoes.add(
      sequenciaPuxadinhos[i] + " puxadinhos"
      );
    if (i < sequenciaPuxadinhos.length-1) {
      instrucoes.add("Trancar 2 vezes");
    }
  }
}
