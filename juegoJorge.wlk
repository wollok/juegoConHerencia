object juego {
  const alimentos = [
    new AlimentoEspecial(position=game.at(3,2),potencia = 2), 
    new AlimentoEspecial(calorias = 10, potencia = 3, position = game.at(1,1)),
    new AlimentoVeloz(calorias = 1, position = game.at(10,6)),
    new AlimentoRebote(calorias = 1, position = game.at(10,4))]
  method iniciar(){
    
    game.width(13)
    game.height(7)
    game.boardGround("fondo.png")
    alimentos.forEach({a=>game.addVisual(a)})
    jorge.centrar()
    game.addVisualCharacter(jorge) 
    game.onCollideDo(jorge, {a=>a.esAgarradoPor(jorge)})

    game.start()
  }

  method agregarAlimento(){
    game.addVisual(
      new AlimentoEspecial(
        calorias = (0..10).anyOne(), 
        potencia = 5,
        position = self.posicionAleatoria()))
  }

  method posicionAleatoria() =
     game.at(0.randomUpTo(game.width()-1), 0.randomUpTo(game.height()-1))


}


object jorge {
  var property energia = 100
  var unaPosicion = null

  method position(nueva){
    unaPosicion = nueva
  }
  method centrar(){
    unaPosicion = game.center()
  }

  method position() = unaPosicion
  
  method image() = "jorge.png"

  method text() = "SOY JORGE"

  method consumir(algo) {
    energia = energia + algo.consumo()
    game.say(self,"tengo energia " + energia)
  }
}


class Alimento {
  const calorias = 1
  var property position = game.origin()

  method consumo()
  
  method esAgarradoPor(alguien){
    alguien.consumir(self)
    game.removeVisual(self)
    game.schedule(1000, {juego.agregarAlimento()})
  }

  //method text() = "SOY Alimento"
  
  method image() 
}

class AlimentoEspecial inherits Alimento {
  var potencia
  override method image() = "alimentoEspecial.png"

  override method consumo() = calorias*10 + potencia

  override method esAgarradoPor(alguien){
    super(alguien)
    game.say(jorge,"un alimento especial")

  }
  method aumentarPotencia(){
    potencia = potencia * 2
  }
}


class AlimentoVeloz inherits Alimento {
  override method image() = "alimentoVeloz.png"
  
  override method consumo() = 100
  override method esAgarradoPor(alguien){
    game.onTick(500, "movimiento", {self.moverse()})
  }
  method moverse(){
    position = position.left(1)
  }
}
class AlimentoRebote inherits AlimentoVeloz {

  override method moverse(){
    super()    
    if (position.x() == 0)
       position = game.at(game.width()-1,position.y())
  }

}