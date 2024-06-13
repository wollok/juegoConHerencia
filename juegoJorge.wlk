object juego {
  const alimentos = [new Alimento(position=game.at(3,2)), new Alimento(calorias = 10, position = game.at(1,1))]
  method iniciar(){
    
    game.width(13)
    game.height(7)
    game.boardGround("fondo.png")
    alimentos.forEach({a=>game.addVisual(a)})
    jorge.centrar()
    game.addVisualCharacter(jorge) 
    game.onCollideDo(jorge, {a=>jorge.consumir(a)})

    game.start()
  }

  method agregarAlimento(){
    game.addVisual(
      new Alimento(
        calorias = (0..10).anyOne(), 
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
    game.removeVisual(algo)
    game.schedule(1000, {juego.agregarAlimento()})
    game.say(self,"tengo energia " + energia)
  }
}


class Alimento {
  const calorias = 1
  var property position = game.origin()

  method consumo() = calorias * 10
  
  method text() = "SOY Alimento"
  
  method image() = "alimento.png"
}