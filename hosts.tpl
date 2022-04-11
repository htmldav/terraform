[deploy]
%{ for ip in deploy ~}
${ip}
%{ endfor ~}

[stage]
%{ for ip in stage ~}
${ip}
%{ endfor ~}