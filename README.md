# IST CYBERSECURITY FORTINET Lab Setup

> **crafted by wolf**

Automated deployment script for provisioning **60+ Kali Linux dual-boot workstations** with a full Fortinet security lab — KVM virtualization, FortiGate, FortiAnalyzer, FortiManager — in a single command.

Built for the **IST Cybersecurity Lab** at SRM Institute of Science & Technology, Tiruchirappalli.



```
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣷⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣶⣿⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⣿⣿⣿⣿⣷⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣶⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⢿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠏⢹⣿⡿⠁⠈⠛⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⠟⠁⠀⢻⣿⣿⠉⢇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠇⠀⠀⠀⠈⢿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⠋⠀⠀⠀⠀⢻⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⢀⡾⠀⠀⠀⢿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⠃⠀⠀⠸⣄⠀⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⠀⣼⡇⠀⠀⠀⠈⣿⣿⣷⡄⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣶⣿⢿⠏⠀⠀⠀⠀⣿⡄⢸⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣧⣿⡇⠀⠀⠀⠀⠙⠈⠻⣿⣾⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⡿⠋⠘⠀⠀⠀⠀⢀⣿⣷⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⠟⠉⣿⡄⠀⠀⠀⠀⠀⠀⠙⢿⡿⣿⣶⣤⣤⣀⣀⣀⣀⣤⣴⣿⡿⣿⠏⠀⠀⠀⠀⠀⠀⠀⣼⡏⠙⢿⣿⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠠⠟⢹⣿⣿⠃⠀⠀⠈⠿⣆⡀⠀⠀⠀⠀⠀⠀⠙⠀⠈⠉⠉⠉⠉⠉⠉⠉⠉⠀⠐⠁⠀⠀⠀⠀⠀⠀⢀⡾⠋⠀⠀⠈⢻⣿⡏⠙⠳⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠇⠀⠀⠀⠀⠀⠀⠙⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠁⠀⠀⠀⠀⠀⠈⢿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠖⠀⠀⠀⣀⣤⠞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡄⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢦⣄⡀⠀⠀⠀⢾⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣧⡖⠀⣠⣾⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣷⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣦⡀⠳⣼⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣤⣾⣿⠟⠀⠀⠀⠀⠀⠀⢀⣠⠀⠀⠀⠀⠀⠀⠀⢠⣿⣷⠀⠀⠀⠀⠀⠀⠀⢀⣀⠀⠀⠀⠀⠀⠀⠘⢿⣿⣦⣼⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⡏⠀⠀⠀⠀⣠⣶⣿⣭⣤⣤⣴⣾⣆⣤⠀⠀⣾⣿⣿⡄⠀⢠⠀⣿⣷⣤⣬⣬⣽⣷⣤⡀⠀⠀⠀⠈⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⡏⠀⠀⠀⢀⣾⣿⠟⠁⠈⠉⠛⠋⠹⣿⠚⣷⣼⣿⣿⣿⣿⣤⡿⣸⡟⠉⠛⠋⠉⠈⠙⢿⣿⣆⠀⠀⠀⠘⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⣟⣿⡿⠿⣿⠿⢷⡶⣄⠀⢻⡆⣿⣿⣿⣿⣿⣿⣿⡇⣿⠁⢀⣴⣶⠿⣿⠿⠿⣿⣾⡆⠀⠀⠀⠸⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⣼⣿⡿⠛⢱⣿⠃⠀⠀⠀⠀⢸⣿⣤⠀⠻⢷⣌⣉⣸⣧⣀⣧⣿⣿⣿⣿⣿⣿⣿⣧⣇⣠⣿⣈⣹⣶⠿⠃⣤⣽⣿⠻⠀⠀⠀⠀⢻⣧⠙⢿⣿⣿⣆⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢠⣾⣿⠋⠀⣰⣿⡇⠀⢀⣤⣾⠃⠈⠉⣽⣷⣤⠀⠈⠉⠉⣻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣉⠉⠉⠁⠤⣶⣿⡉⠉⠀⢻⣦⣀⠀⠈⣿⣧⡀⠘⢿⣿⣆⠀⠀⠀⠀
⠀⠀⠀⢠⣿⡿⠁⢀⣼⣿⣿⣠⣶⣿⣿⡇⠀⠐⠾⠿⠿⢶⣶⣾⠿⣶⣶⣿⡿⢿⣿⣿⣿⣿⣿⣿⠟⣿⣶⣤⠾⢿⣶⣶⠾⠿⠿⠖⠀⠈⣿⣿⣷⣦⣸⣿⣷⡄⠀⠹⣿⣧⠀⠀⠀
⠀⠀⢀⣾⡟⠁⢀⣾⣿⣿⠿⠋⢠⣿⣿⢀⡀⠀⠀⠀⠒⠋⠉⠁⠀⠘⣿⠟⠀⠀⢿⣿⣿⣿⣿⠃⠀⠙⣿⣿⠀⠀⠉⠙⠓⠂⠀⠀⠀⡀⢸⣿⣇⠉⠻⢿⣿⣿⣆⠀⠹⣿⡆⠀⠀
⠀⠀⢸⡟⠁⢀⣾⡿⠋⠁⠀⠀⢸⣿⣿⡟⠁⠀⢀⣀⠀⠀⠀⠀⠀⢸⡿⠀⠀⠀⠈⢿⣿⣿⠁⠀⠀⠀⠙⣿⠀⠀⠀⠀⠀⠀⣀⠀⠀⠹⣾⣿⣿⠀⠀⠀⠉⠻⢿⡆⠀⠹⣷⡀⠀
⠀⠀⡿⠁⠀⡸⠋⠀⠀⠀⠀⠀⢸⣿⣿⢃⣤⣶⣿⠁⠀⠀⠀⠀⠀⢸⠃⠀⠀⠀⠀⠀⢿⠃⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠹⣿⣦⡀⢹⣿⣿⠃⠀⠀⠀⠀⠈⢻⡄⠀⢹⡇⠀
⠀⢸⡇⠀⢀⣡⣤⣶⣶⣶⡇⠀⢸⣿⣿⡿⢿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠇⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⣿⣿⢿⣿⣿⡿⠀⠀⢷⣶⣶⣦⣄⡁⠀⠈⣇⠀
⠀⣸⠁⣰⣾⠟⠹⣿⣿⣿⠁⠀⠈⣿⡿⠁⠘⣿⣇⠀⠀⠀⠀⡀⠀⠀⠀⠀⣤⣶⣿⣿⣿⣿⣿⣷⣦⡀⠀⠀⠀⠀⡀⠀⠀⠀⢀⣿⡟⠀⢹⣿⡇⠀⠀⢸⣿⣿⡟⠙⠿⣶⡀⢸⡀
⢀⣿⣾⠏⠀⠀⠀⢻⣿⣿⡄⠀⠀⢸⡇⠀⠀⠘⣿⣄⠀⠀⣸⡃⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⣿⠀⠀⢀⣾⡟⠀⠀⠀⡿⠁⠀⠀⣸⣿⣿⠇⠀⠀⠈⠳⣾⡇
⣸⠟⠁⠀⠀⠀⠀⠘⣿⣿⡇⠀⠀⠀⠁⠀⠀⠀⠈⢿⣦⡀⢹⣧⠀⠀⠀⠘⠛⠛⠛⣿⣿⣿⡟⠛⠛⠟⠀⠀⠀⢀⣿⠀⣠⣿⠏⠀⠀⠀⠀⠁⠀⠀⠀⣿⣿⡏⠀⠀⠀⠀⠀⠙⢷
⠋⠀⠀⠀⠀⠀⠀⠀⠸⣿⣷⠀⠀⠀⣀⡀⠀⠀⠀⠀⠙⢿⣦⣿⣄⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⢀⣾⣯⣾⠟⠁⠀⠀⠀⠀⢀⡀⠀⠀⢸⣿⡟⠁⠀⠀⠀⠀⠀⠀⠈
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣇⠀⢰⣿⠻⢦⣄⠀⠀⠀⠀⠙⣿⣿⣦⣀⠀⠀⠀⢈⣿⣿⣿⡋⠀⠀⠀⢀⣠⣾⣿⡟⠁⠀⠀⠀⢀⣴⡾⢻⡇⠀⢠⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣇⢸⣿⠀⠀⠙⢷⣄⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⠛⠛⠉⠙⠛⢻⣿⣿⣿⣿⣿⠋⠀⠀⠀⢀⡴⠛⠁⠀⢸⡇⢠⣿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⠀⠀⠀⠀⠘⢷⡀⠀⠀⠘⣿⣿⣿⣿⣿⣷⣦⣤⣤⣶⣿⣿⣿⣿⣿⡏⠀⠀⢀⣴⠋⠀⠀⠀⠀⢸⣷⣿⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⡇⠀⠀⠀⠀⠀⠻⣦⠀⠀⠹⡟⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠙⡿⠀⠀⢠⡾⠁⠀⠀⠀⠀⢀⣾⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠹⣧⡀⠀⠁⡄⢻⣿⣿⣿⣿⣿⣿⣿⣿⠁⣄⠁⠀⣰⡿⠀⠀⠀⠀⠀⠀⠈⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣷⡀⣼⣧⠀⢿⠟⣿⣿⣿⡿⣿⠃⢀⣿⠀⣰⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⠀⠈⣇⢻⣿⣿⠀⡟⠀⢸⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⠟⣿⡄⠀⠹⠘⣿⡿⠘⠀⠀⣿⡟⢿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⢿⣷⠀⠀⠀⣿⡇⠀⠀⢠⣿⠁⢸⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡟⠀⠈⣿⡄⠀⠀⢿⠀⠀⠀⣾⡏⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠃⠀⠀⠹⣷⠀⠀⠀⠀⠀⣰⡿⠀⠀⠀⢿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣧⢀⡄⣄⢀⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⠀⣿⣾⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣆⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢈⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
```

---

## What It Does

| Step | Description |
|------|-------------|
| **1** | `apt update` |
| **2** | `apt full-upgrade` |
| **3** | Install KVM, libvirt, virt-manager, virtinst, expect |
| **4** | Configure libvirt default NAT network |
| **5** | Extract FortiGate, FortiAnalyzer, FortiManager qcow2 from zips + create log/data disks |
| **6** | Deploy all 3 Fortinet VMs with correct disk layout |
| **7** | **Initialize VM disks** — boot each VM, run `execute lvm start` + `execute lvm extend` to format data disks inside FortiOS |
| **8** | GRUB — enable os-prober, set **Windows as default boot**, **5s timeout** |
| **9** | Verify — VM status, DHCP leases, disk images, GRUB config |

---

## VM Disk Layout

Following [Fortinet KVM Administration Guides](https://docs.fortinet.com/document/fortigate-private-cloud/7.6.0/kvm-administration-guide/), each VM is deployed with the correct disk configuration:

| VM | RAM | vCPUs | Disk 1 (System) | Disk 2 (Data/Log) |
|----|-----|-------|-----------------|---------------------|
| FortiGate | 2 GB | 1 | `fortios.qcow2` | **30 GB** log disk |
| FortiAnalyzer | 4 GB | 2 | `faz.qcow2` | **200 GB** data disk |
| FortiManager | 4 GB | 2 | `fmg.qcow2` | **200 GB** data disk |

**Step 7** automatically initializes LVM inside each VM so the data disks are formatted and usable. If auto-init fails, manual instructions are displayed:

```
sudo virsh console FortiAnalyzer
Login: admin / (no password)
# execute lvm start
# execute lvm extend
```

FortiAnalyzer supports up to 12 virtual log disks via `execute lvm extend`.

---

## Features

### 🔧 Auto Permission Fix
Runs on every launch and at key steps. Fixes:
- `/var/lib/libvirt/images` ownership and mode
- qcow2 file ownership (`libvirt-qemu:kvm`) and chmod `660`
- Home directory traversal for libvirt
- Libvirt socket permissions
- User group membership (`libvirt`, `kvm`)
- Safe glob handling — no errors when no images exist yet

### 📂 Custom Fortinet Path
On first run, choose where your Fortinet images are:
```
  Fortinet Image Source:

    [1]  Default: ~/Documents/Fortinet
    [2]  Custom path

  ▸ Choice:
```
Validates the directory structure and shows which images are found. Path is saved across reboots. Change anytime from the menu with option `[5]`.

### 💾 State Persistence
Saves progress to `~/.wolf_setup_state`. Reboot mid-install, re-run the script, it picks up where it left off.

### 🔁 Auto Error Recovery
Retries up to 3 times per command with pattern-matched fixes:
- **dpkg locks** → clears locks, runs `dpkg --configure -a`
- **Broken packages** → `apt --fix-broken install`
- **GPG errors** → refreshes `kali-archive-keyring`
- **Network failures** → animated countdown + restarts NetworkManager
- **libvirt errors** → restarts `libvirtd`
- **Permission denied** → full permission repair cycle

### 🪟 GRUB — Windows Default
- Uses `sed` to **replace** `GRUB_DISABLE_OS_PROBER` (not append duplicates)
- Sets `GRUB_TIMEOUT=5` (5 second menu)
- Sets `GRUB_TIMEOUT_STYLE=menu` (visible menu, not hidden)
- Auto-detects Windows entry and sets it as **default boot** via `grub-set-default`

### 🎯 Range Selection
Run specific steps: `1-3`, `5,7-9`, `1,3,6-9`

### ✨ Animations
Braille spinner, progress bar, typewriter text, wolf run transition, countdown timer

---

## Prerequisites

**Expected directory structure** (default or custom path):

```
Fortinet/
├── FortiAnalyser/
│   └── FAZ_VM64_KVM-v7.x.x.M-buildXXXX-FORTINET.out.kvm.zip
├── FortiGate/
│   └── FGT_VM64_KVM-v7.x.x.M-buildXXXX-FORTINET.out.kvm.zip
└── FortiManager/
    └── FMG_VM64_KVM-v7.x.x.M-buildXXXX-FORTINET.out.kvm.zip
```

> Distribute the Fortinet KVM zip files to all machines before running the script (USB, network share, LocalSend, etc.)

---

## Usage

```bash
chmod +x setup-lab.sh
./setup-lab.sh
```

### Menu

```
  Select Mode:

    [1]  Auto-run all (resumes from step 1)
    [2]  Manual — pick steps  (e.g. 1-3  5,7-9  4)
    [3]  Reset state & start fresh
    [4]  Show progress
    [5]  Change Fortinet path
    [0]  Quit

  ▸ Choice:
```

### Examples

```bash
# Auto-run everything
▸ Choice: 1

# Run only KVM install + network
▸ Choice: 2
▸ Enter steps: 3-4

# Run extract, deploy, and init disks
▸ Choice: 2
▸ Enter steps: 5-7

# Fix GRUB only
▸ Choice: 2
▸ Enter steps: 8

# Check progress after a reboot
▸ Choice: 4
```

---

## After Setup

```bash
# Check VM IPs
sudo virsh net-dhcp-leases default

# Access FortiGate CLI
sudo virsh console FortiGate

# Open virt-manager GUI
virt-manager

# Access FortiGate web UI
https://<fortigate-ip>

# Access FortiAnalyzer web UI
https://<fortianalyzer-ip>

# Access FortiManager web UI
https://<fortimanager-ip>
```

Default Fortinet credentials: `admin` / *(no password — set on first login)*

---

## Files

| File | Purpose |
|------|---------|
| `~/.wolf_setup_state` | Current step progress (0–9) |
| `~/.wolf_setup.log` | Full execution log |
| `~/.wolf_fortinet_path` | Saved Fortinet image path |

---

## Troubleshooting

### LVM disks not initialized
If Step 7 auto-init didn't work (expect timeout), run manually:
```bash
sudo virsh console FortiAnalyzer
# Login: admin / (no password)
execute lvm start
execute lvm extend
```

### Windows not showing in GRUB
Mount the Windows EFI partition first:
```bash
sudo mount /dev/<windows-efi-partition> /mnt
sudo os-prober
sudo update-grub
```

### Permission denied on VM start
Re-run the script and select Step 6 — permission fix runs automatically before deployment.

### VM stuck or unresponsive
```bash
sudo virsh destroy <VM_Name>
sudo virsh start <VM_Name>
sudo virsh console <VM_Name>
```

---

## References

- [FortiGate KVM Administration Guide (7.6)](https://docs.fortinet.com/document/fortigate-private-cloud/7.6.0/kvm-administration-guide/)
- [FortiAnalyzer KVM Administration Guide (7.6)](https://docs.fortinet.com/document/fortianalyzer-private-cloud/7.6.0/kvm-administration-guide/)
- [Fortinet Community — KVM/QEMU Deployment](https://community.fortinet.com/t5/FortiManager/Technical-Tip-Deployment-under-KVM-QEMU-environment-of/ta-p/264928)

---

## Tested On

- Kali Linux 2024.x / 2025.x (GNOME)
- Dual-boot with Windows 10/11 (UEFI)
- 60 workstations — SRM IST Cybersecurity Lab

---

## License

MIT

---

<p align="center">
  <b>crafted by wolf</b>
</p>
