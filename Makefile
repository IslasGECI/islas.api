# 1. _all_ enlista todos los objetivos principales
#
all: README.pdf

# 2. Declaración de las variables
#
archivosHGT = \
  inst/extdata/N18W088.hgt \
  inst/extdata/N18W092.hgt \
  inst/extdata/N18W111.hgt \
  inst/extdata/N18W112.hgt \
  inst/extdata/N18W115.hgt \
  inst/extdata/N19W111.hgt \
  inst/extdata/N20W087.hgt \
  inst/extdata/N20W088.hgt \
  inst/extdata/N20W106.hgt \
  inst/extdata/N21W087.hgt \
  inst/extdata/N21W106.hgt \
  inst/extdata/N21W107.hgt \
  inst/extdata/N22W090.hgt \
  inst/extdata/N24W111.hgt \
  inst/extdata/N25W111.hgt \
  inst/extdata/N25W112.hgt \
  inst/extdata/N26W112.hgt \
  inst/extdata/N28W113.hgt \
  inst/extdata/N28W116.hgt \
  inst/extdata/N28W119.hgt \
  inst/extdata/N29W113.hgt \
  inst/extdata/N29W119.hgt \
  inst/extdata/N27W115.hgt \
  inst/extdata/N27W116.hgt \
  inst/extdata/N29W116.hgt \
  inst/extdata/N30W117.hgt \
  inst/extdata/N31W117.hgt \
  inst/extdata/N32W118.hgt \
  inst/extdata/N28W114.hgt \
  inst/extdata/N25W110.hgt

archivosShape = \
  inst/extdata/USA_adm0.shp \
  inst/extdata/alijos_LCosta.shp \
  inst/extdata/asuncion_LCosta.shp \
  inst/extdata/CAN_adm0.shp \
  inst/extdata/CAN_adm1.shp \
  inst/extdata/CAN_adm2.shp \
  inst/extdata/CAN_adm3.shp \
  inst/extdata/coronado_LCosta.shp \
  inst/extdata/farallon_de_san_ignacio_LCosta_UTM-12.shp \
  inst/extdata/guadalupe_LCosta.shp \
  inst/extdata/inst/extdata/san_martin_LCosta.shp \
  inst/extdata/MEX_adm0.shp \
  inst/extdata/MEX_adm1.shp \
  inst/extdata/natividad_LCosta.shp \
  inst/extdata/partida_LCosta_UTM-12.shp \
  inst/extdata/san_benito_LCosta.shp \
  inst/extdata/san_jeronimo_LCosta.shp \
  inst/extdata/san_pedro_martir_LCosta_UTM-12.shp \
  inst/extdata/san_roque_LCosta.shp \
  inst/extdata/todos_santos_LCosta_2014.shp \
  inst/extdata/USA_adm1.shp \
  inst/extdata/USA_adm2.shp

# 3. Reglas para construir los objetivos principales

README.pdf: README.md # La fuente README.md debe estar en UTF-8 por el pandoc
	pandoc README.md -o README.pdf
	start "" /max "README.pdf"

# 4. Reglas para construir las dependencias
#
$(archivosHGT) $(archivosShape):
	if not exist "$(subst /,\,$(@D))" mkdir $(subst /,\,$(@D))
	copy \\%COMPUTERNAME%\Datos\$(@F) $(subst /,\,$(@D))

# 5. Reglas del resto de los phonies
#

# Elimina lo que se genera con Make
clean:
	-del /F /S /Q resultados 1>nul & rmdir /S /Q resultados
	-del /S /Q inst\extdata\*.hgt
	-del entrega\*.aux
	-del entrega\*.bbl
	-del entrega\*.bcf
	-del entrega\*.blg
	-del entrega\*.docx
	-del entrega\*.log
	-del entrega\*.out
	-del entrega\*.pdf
	-del entrega\*.run.xml
	-del entrega\*.synctex
	-del entrega\*.toc
	-del inst\extdata\*.shp
	-del README.pdf

# Esta sección corre las pruebas y demostraciones
pruebas:
	cd test && runMatlab runtests

# Obtener datos
datos: $(archivosShape) $(archivosHGT)