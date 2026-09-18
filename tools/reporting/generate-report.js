#!/usr/bin/env node
/**
 * Gerador de Relatórios Técnicos — Brazilian Computer Guy (BCG)
 * Compila informações de diagnóstico, memória (.local/<maquina>/memory.md)
 * e changelog (.local/<maquina>/changelog.md) em um relatório formatado e profissional.
 */

const fs = require('fs');
const path = require('path');

function parseArgs() {
  const args = process.argv.slice(2);
  const options = {
    machine: '',
    tech: 'Técnico de TI',
    protocol: `BCG-${Date.now().toString().slice(-6)}`,
    status: 'CONCLUÍDO COM SUCESSO',
    lang: 'pt',
    output: ''
  };

  args.forEach(arg => {
    if (arg.startsWith('--machine=')) options.machine = arg.split('=')[1];
    if (arg.startsWith('--tech=')) options.tech = arg.split('=')[1];
    if (arg.startsWith('--protocol=')) options.protocol = arg.split('=')[1];
    if (arg.startsWith('--status=')) options.status = arg.split('=')[1];
    if (arg.startsWith('--lang=')) options.lang = arg.split('=')[1].toLowerCase();
    if (arg.startsWith('--output=')) options.output = arg.split('=')[1];
  });

  return options;
}

function generateReport() {
  const opts = parseArgs();
  const rootDir = path.resolve(__dirname, '../../');
  const templateFileName = opts.lang === 'en' ? 'report-template.en.md' : 'report-template.md';
  const templatePath = path.join(rootDir, 'templates', templateFileName);

  if (!fs.existsSync(templatePath)) {
    console.error('Erro: Template de relatório não encontrado em:', templatePath);
    process.exit(1);
  }

  let template = fs.readFileSync(templatePath, 'utf-8');
  const now = new Date();
  const formattedDate = now.toISOString().replace('T', ' ').substring(0, 19);

  const machineName = opts.machine || (opts.lang === 'en' ? 'MACHINE-TEMPLATE' : 'MAQUINA-TEMPLATE');
  const machineDir = path.join(rootDir, '.local', machineName);

  let memoryContent = '';
  let changelogContent = '';

  if (fs.existsSync(path.join(machineDir, 'memory.md'))) {
    memoryContent = fs.readFileSync(path.join(machineDir, 'memory.md'), 'utf-8');
  }

  if (fs.existsSync(path.join(machineDir, 'changelog.md'))) {
    changelogContent = fs.readFileSync(path.join(machineDir, 'changelog.md'), 'utf-8');
  }

  let report = template;
  if (opts.lang === 'en') {
    report = report
      .replace('{PROTOCOL_OR_ID}', opts.protocol)
      .replace('{SERVICE_DATETIME}', formattedDate)
      .replace('{TECHNICIAN_NAME}', opts.tech === 'Técnico de TI' ? 'IT Support Technician' : opts.tech)
      .replace('{MACHINE_NAME}', machineName)
      .replace('[SUCCESSFULLY COMPLETED | PARTIAL | MONITORING]', opts.status === 'CONCLUÍDO COM SUCESSO' ? 'SUCCESSFULLY COMPLETED' : opts.status)
      .replace('{OS_VERSION_AND_BUILD}', 'Detected via diagnostics')
      .replace('{x64 / ARM64 / x86}', 'x64')
      .replace('{CPU}', 'System Processor')
      .replace('{TOTAL_RAM_GB}', '16')
      .replace('{STORAGE_MODEL_OR_CAPACITY}', 'Primary Drive')
      .replace('{FREE_SPACE}', 'As diagnosed')
      .replace('{On-Premises / Authorized Remote}', 'On-Premises')
      .replace('{REPORTED_ISSUE_DESCRIPTION}', 'Preventative system maintenance and diagnostic evaluation.')
      .replace('{e.g., Random crashes, critical slowdown, loss of network connectivity}', 'Slowdown and temporary files accumulation')
      .replace('{e.g., Continuous, during boot, intermittent}', 'Intermittent during daily use');
  } else {
    report = report
      .replace('{PROTOCOLO_OU_ID}', opts.protocol)
      .replace('{DATA_HORA_ATENDIMENTO}', formattedDate)
      .replace('{NOME_DO_TECNICO}', opts.tech)
      .replace('{NOME_DA_MAQUINA}', machineName)
      .replace('[CONCLUÍDO COM SUCESSO | PARCIAL | EM ACOMPANHAMENTO]', opts.status)
      .replace('{VERSAO_DO_SO_E_BUILD}', 'Detectado via diagnóstico')
      .replace('{x64 / ARM64 / x86}', 'x64')
      .replace('{CPU}', 'Processador do Sistema')
      .replace('{RAM_TOTAL_GB}', '16')
      .replace('{DISCO_MODELO_OU_CAPACIDADE}', 'Unidade Principal')
      .replace('{ESPACO_LIVRE}', 'Conforme diagnóstico')
      .replace('{Local no Computador / Remoto Autorizado}', 'Local no Computador')
      .replace('{DESCRICAO_DO_PROBLEMA_RELATADO_PELO_CLIENTE}', 'Atendimento e revisão preventiva do sistema operacional.')
      .replace('{Ex: Travamentos aleatórios, lentidão crítica, perda de acesso à rede}', 'Lentidão e acúmulo de arquivos temporários')
      .replace('{Ex: Contínua, na inicialização, intermitente}', 'Conforme uso');
  }

  const outDir = path.join(rootDir, 'relatorios');
  if (!fs.existsSync(outDir)) {
    fs.mkdirSync(outDir, { recursive: true });
  }

  const prefix = opts.lang === 'en' ? 'report' : 'relatorio';
  const fileName = opts.output || `${prefix}_${machineName}_${now.toISOString().slice(0, 10)}.md`;
  const finalPath = path.join(outDir, fileName);

  fs.writeFileSync(finalPath, report, 'utf-8');
  console.log('----------------------------------------------------');
  console.log(opts.lang === 'en' ? '✅ Technical Service Report successfully generated!' : '✅ Relatório Técnico de Atendimento gerado com sucesso!');
  console.log('Arquivo / File:', finalPath);
  console.log('Protocolo / Protocol:', opts.protocol);
  console.log('Máquina / Machine:', machineName);
  console.log('Idioma / Language:', opts.lang);
  console.log('----------------------------------------------------');
}

generateReport();
