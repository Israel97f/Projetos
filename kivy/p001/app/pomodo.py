from itertools import cycle

from kivy.lang import Builder
from kivy.properties import StringProperty, BooleanProperty
from kivymd.app import MDApp
from kivymd.uix.floatlayout import FloatLayout, MDFloatLayout

class Cycle:
    def __init__(self):
        self.cycle = [Time(25), Time(5), Time(25), Time(5), Time(25), Time(30)]

    def __iter__(self):
        return self

    def __next__(self):
        return next(self.cycle)


class Time:
    def __init__(self, time):
        self.time = self.time * 60

    def decrementar(self):
        self.time -= 1
        return self.time

    def __str__(self):
        return '{:02d}:{:02d}'.format(divmod(self.time, 60))

class Pomodoro(MDFloatLayout):
    timer_string = StringProperty('25:00')
    button_string = StringProperty('Iniciar')
    running = BooleanProperty(False)

    def start(self):
        self.button_string = 'Palsar'
        if not self.running:
            self.running = True
    
    def stop(self):
        self.button_string = 'Reinciar'
        if self.running:
            self.running = False

    def click(self):
        if self.running:
            self.stop()
        else:
            self.start()

class PomoGumo(MDApp):
    def build(self):
        return Builder.load_file('app/pomodoro.kv')
