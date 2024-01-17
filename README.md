<img title="" src="https://github.com/git-marktime/water-sim-testbench/blob/main/RHDS%20Testbench%20Src/GameScreenshotPreview.png?raw=true" alt="Image" width="412" data-align="center">

# RHDS TestBench

---

  This is a small piece of a much larger project. If bugs are found, please open an issue. The purpose of this program is to break it so I can fix the larger project.

### To Do

- [ ] System Malfunctions

- [ ] Annunciators and Warning System

- [x] Variable Power Demand

### Resources Used

- https://usbr.gov/power/edu/pamphlet.pdf

- [https://users.metu.edu.tr/bertug/CVE471/CVE471 Lecture Notes 9 - Hydroelectric Power.pdf](https://users.metu.edu.tr/bertug/CVE471/CVE471%20Lecture%20Notes%209%20-%20Hydroelectric%20Power.pdf)

- https://auislandora.wrlc.org/islandora/object/1213capstones%3A7/datastream/PDF/view

- [List of largest reservoirs in the United States - Wikipedia](https://en.wikipedia.org/wiki/List_of_largest_reservoirs_in_the_United_States)

### Resources Provided

- [Realistic Hydroelectric Dam Simulator](https://discord.gg/JUjfPNJXqz)

- [Power Output](https://www.desmos.com/calculator/xruiaxcldj)

- [Turbine Power Coefficient](https://www.desmos.com/calculator/szporfkyqd)

- [Gate Flow Formula](https://www.desmos.com/calculator/lue1htxwdw)

### Math Formulas Used

$$
P_{out} = 1027\cdot\pi\left(\frac{T_{r}}{2}\right)^{2}\cdot T_{V}^{2}\cdot\frac{T_{r}}{T_{V}}\cdot T_r\cdot T_{eff}
$$

$$
T_{eff}=-0.0000085\left(T_v-100\right)\left(T_v-750\right)
$$
