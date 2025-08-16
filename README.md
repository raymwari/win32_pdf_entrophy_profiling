# win32_pdf_entrophy_profiling
Pdf stream entropic profiling via Shannon entropy

## Prerequisites:
https://www.nasm.us <br>
https://www.godevtool.com  <br>
https://sourceforge.net/projects/mingw-w64/ <br>

## shannon.dll:
Ensure your running the correct version gcc : `gcc --version` <br>

<img width="1366" height="298" alt="Screenshot (111)" src="https://github.com/user-attachments/assets/8a7fd209-2a8d-40b4-b605-c2434d74b90d" /> <br>


__Compile dll:__ <br>
`gcc -Wall -Wextra -Werror -shared -o shannon.dll main.c` <br>

## Error codes (check stderr):
https://learn.microsoft.com/en-us/windows/win32/debug/system-error-codes--0-499-

__Custom codes:__ <br>
`1701`: `target.pdf` contains no data <br>
`1702`: `target.pdf` contains no compressed data <br>
`1703`: stream length may have exceeded `100kb` (consider increasing this length from source) <br>
`1704`: heap memory allocation failed

## Important:
Program expects a maximum length of `256` __unique__ characters in each stream <br>
Scores below `40` indicate low entropy, values `40` to `60` medium entropy, `60` to `100` high entropy and beyond `100` very high entropy <br>

__Shannon method__: <br>
H(X) = -∑ p(xᵢ) * log₂(p(xᵢ)) <br>

## Demo:

https://github.com/user-attachments/assets/853cb621-a68a-44e9-92a9-e92b219123ac




