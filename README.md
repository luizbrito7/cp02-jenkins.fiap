<h1 align="center">
  CP02 - Jenkins CI/CD Pipeline
</h1>

<p align="center">
  <a href="https://youtu.be/8zGAl_VttFs">
    <img src="docs/image.png" alt="Arquitetura do projeto - clique para assistir a apresentação" />
  </a>
</p>

<h4 align="center"><a href="https://youtu.be/8zGAl_VttFs">Clique para assistir a apresentação no YouTube</a></h4>

<p align="center">
  <a href="https://skillicons.dev">
    <img src="https://skillicons.dev/icons?i=jenkins,docker,terraform,azure,nodejs,express,linux,bash,github" alt="Stacks" />
  </a>
</p>

## Qual a finalidade do projeto?

Checkpoint 02 da disciplina de **Computação em Nuvem** - FIAP. O projeto implementa uma esteira completa de **CI/CD** utilizando **Jenkins**, **Docker** e infraestrutura provisionada na **Azure** via **Terraform**, com deploy automatizado de uma API Node.js a cada push na branch `main`.

> [!NOTE]
> A apresentação completa do projeto - incluindo a infraestrutura provisionada, a pipeline em execução e o deploy automatizado - está disponível no [vídeo do YouTube](https://youtu.be/8zGAl_VttFs).


<br>

## O que foi construído

### Infraestrutura (Terraform + Azure)

- Resource Group único na região `eastus`
- Virtual Network com subnet dedicada ao laboratório
- Duas Virtual Machines Ubuntu 22.04 (Standard_B2s):
  - `vm-jenkins-lab` - servidor Jenkins rodando em container Docker
  - `vm-app-lab` - servidor de deploy da aplicação
- Network Security Groups com regras para SSH, HTTP, porta 8080 (Jenkins) e porta 3000 (App)
- IPs públicos estáticos para ambas as VMs
- Chaves SSH individuais por VM

### Pipeline CI/CD (Jenkins)

- **CI - Build:** build da imagem Docker da aplicação com tag baseada no `BUILD_NUMBER`
- **CI - Push:** push da imagem para o GitHub Container Registry (GHCR)
- **CD - Deploy:** deploy automático na `vm-app-lab` via SSH, somente na branch `main`
- Trigger automático via webhook do GitHub a cada push

### Aplicação

- API REST em Node.js com Express
- Endpoint `/` retorna versão, nome da imagem e timestamp
- Endpoint `/health` retorna status da aplicação
- Containerizada com Docker e publicada no GHCR


<br>

## Tecnologias utilizadas

- **Jenkins:** servidor de automação para orquestração da pipeline CI/CD;
- **Docker:** containerização da aplicação e do próprio Jenkins;
- **Terraform:** provisionamento da infraestrutura como código na Azure;
- **Azure:** nuvem onde toda a infraestrutura é provisionada;
- **Node.js + Express:** runtime e framework da API exposta pelo pipeline;
- **GitHub Container Registry (GHCR):** registro das imagens Docker geradas;
- **Linux (Ubuntu 22.04):** sistema operacional das VMs;
- **Git:** controle de versão e gatilho dos webhooks de build.


<br>

## Estrutura do repositório

```
cp02-jenkins.fiap/
├── Jenkinsfile                  # Definicao da pipeline CI/CD
├── app/                         # Codigo-fonte da aplicacao
│   ├── Dockerfile               # Imagem Docker da aplicacao
│   ├── package.json
│   └── src/
│       └── index.js             # Entrypoint da API Node.js
└── terraform/                   # Infraestrutura como codigo (Azure)
    ├── main.tf                  # Recursos principais (VMs, VNet, NSG)
    ├── variables.tf             # Variaveis de entrada
    ├── outputs.tf               # Outputs (IPs, nomes)
    └── scripts/                 # Scripts de provisionamento das VMs
        ├── install-docker.sh
        └── install-jenkins.sh
```


<br>

## Grupo

| Nome | RM |
|---|---|
| Anderson Huang | rm565920@fiap.com.br |
| Bruno Henrique | rm566277@fiap.com.br |
| Ronaldo Attamah | rm564630@fiap.com.br |
| Luiz Brito | rm562192@fiap.com.br |
| Guylherme Miguel | rm562374@fiap.com.br |
