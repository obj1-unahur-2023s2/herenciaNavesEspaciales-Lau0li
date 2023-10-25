class Nave {
	var velocidad = 0
	var distanciaAlSol = 0
	var combustible = 0
	
	method cargarCombustible(cantidad){combustible += cantidad}
	method descargarCombustible(cantidad){combustible = 0.max(combustible-cantidad)}
	method combustible() = combustible
	
	method acelerar(v){
		velocidad = 100000.min(v+velocidad)
	}
	method desacelerar(v){
		velocidad = 0.max(velocidad-v)
	}
	
	method irHaciaElSol(){
		distanciaAlSol = 10
	}
	
	method escaparDelSol(){
		distanciaAlSol = -10
	}
	
	method estaDeRelajo() = true
	
	method ponerseParaleloAlSol(){
		distanciaAlSol = 0
	}
	
	method acercarseUnPocoAlSol(){distanciaAlSol = 10.min(distanciaAlSol+1)}
	method alejarseUnPocoAlSol(){distanciaAlSol = -10.max(distanciaAlSol-1)}
	method prepararViaje(){
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	method estaTranquila() = combustible > 4000 and velocidad > 12000
	method avisar(){}
	method escapar(){}
	method recibirAmenaza(){}
}

class NaveBaliza inherits Nave{
	var baliza
	var cantidadDeCambiosDeBaliza = 0
	
	override method avisar(){self.cambiarColorDeBaliza("rojo")}
	override method escapar(){self.irHaciaElSol()}
	override method recibirAmenaza(){	
		self.avisar()
		self.escapar()
	}
	override method estaDeRelajo() = cantidadDeCambiosDeBaliza == 0
	method cambiarColorDeBaliza(nuevoColor){
		baliza = nuevoColor
		cantidadDeCambiosDeBaliza ++
	}
	override method prepararViaje(){
		super()
		self.ponerseParaleloAlSol()
		self.cambiarColorDeBaliza("verde")
	}
	override method estaTranquila() = super() and baliza != "rojo"
}
class NavePasajeros inherits Nave{
	var cantidadDePasajeros
	var racionesDeComida = 0
	var racionesDeBebidas = 0
	var cantidadDeracionesDeComidaServidas = 0
	
	override method avisar(){
		self.descargarRacionesDeComida(cantidadDePasajeros)
		self.descargarRacionesDeBebidas(cantidadDePasajeros*2)
	}
	override method escapar(){
	self.acelerar(velocidad)
	}
	override method recibirAmenaza(){	
		self.avisar()
		self.escapar()
	}
	override method estaDeRelajo() = cantidadDeracionesDeComidaServidas < 50
	override method prepararViaje(){
		super()
		self.acercarseUnPocoAlSol()
		self.cargarRacionesDeComida(4*cantidadDePasajeros)
		self.cargarRacionesDeBebidas(6*cantidadDePasajeros)
	}
	
	method cantidadDePasajeros() = cantidadDePasajeros
	method cargarRacionesDeComida(raciones){
		racionesDeComida += raciones
	}
	method cargarRacionesDeBebidas(raciones){
		racionesDeBebidas += raciones
	}
	method descargarRacionesDeComida(raciones){
		cantidadDeracionesDeComidaServidas += raciones
		racionesDeComida = 0.max(racionesDeComida-raciones)
		
	}
	method descargarRacionesDeBebidas(raciones){
		racionesDeBebidas = 0.max(racionesDeBebidas-raciones)
	}
}
class NaveDeCombate inherits Nave{
	var visible = true
	var mensajesEmitidos = []
	var misilesDesplegados = false
	
	override method estaDeRelajo() = self.esEscueta()
	override method avisar(){self.emitirMensaje("Amenaza recibida")}
	override method escapar(){
	self.acercarseUnPocoAlSol()
	self.acercarseUnPocoAlSol()
	}
	override method recibirAmenaza(){	
		self.avisar()
		self.escapar()
	}
	override method estaTranquila() = super() and !misilesDesplegados
	method estaInvisible() = !visible
	method ponerseInvisible(){
		visible = false
	}
	method ponerseVisible(){
		visible = true
	}
	
	method desplegarMisiles(){
		misilesDesplegados = true
	}
	method replegarMisiles(){
		misilesDesplegados = false
	}
	method misilesDesplegados() = misilesDesplegados
	
	method emitirMensaje(mensaje){
		mensajesEmitidos.add(mensaje)
	}
	method mensajesEmitidos()= mensajesEmitidos
	method primerMensajeEmitido() = mensajesEmitidos.get(0)
	method ultimoMensajeEmitido() = mensajesEmitidos.get(mensajesEmitidos.size()-1)
	method esEscueta() = !mensajesEmitidos.any({n => n.size() > 30})
	method emitioMensaje(mensaje) = mensajesEmitidos.contains(mensaje)

	override method prepararViaje(){
		super()
		self.replegarMisiles()
		self.ponerseVisible()
		self.emitirMensaje("Saliendo")
		self.acelerar(15000)
	}
}
class NaveHospital inherits NavePasajeros{
	var quirofanoPreparados = false
	
	override method recibirAmenaza(){super()
		self.prepararQuirofano()
	}
	override method estaTranquila() = super() and !quirofanoPreparados
	method prepararQuirofano(){quirofanoPreparados = true}
	method quirofanoPreparados() = quirofanoPreparados
}
class NaveDeCombateSilenciosa inherits NaveDeCombate{
	override method estaTranquila() = super() and self.estaInvisible()
	override method recibirAmenaza(){super()
		self.desplegarMisiles()
		self.ponerseInvisible()
	}
}
