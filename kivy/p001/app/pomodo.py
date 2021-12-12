from itertools import cycle
from types import new_class

from kivy.lang import Builder
from kivy.clock import Clock
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
    cycle = Cycle()

    def __init__ (self):
        seper().__init__(**kwargs)
        self._time = next(self.cycle)
        self.time_string = str(self._time)

    def start(self):
        self.button_string = 'Palsar'
        if not self.running:
            self.running = True
            Clock.schedule_interval(self.update, 1)
    
    def stop(self):
        self.button_string = 'Reinciar'
        if self.running:
            self.running = False

    def click(self):
        if self.running:
            self.stop()
        else:
            self.start()
    def update (self, *args):
        time = self._time.decrementar()
        
        if time == 0:
            self.stop()
            self._time = next(self.cycle)

        self.timer_string = str(self._time)

class PomoGumo(MDApp):
    def change_color(self):
        theme = self.theme_cls.theme_style
        if theme == 'Dark':
            self.theme_cls.theme_style = 'Light'
        else:
            self.theme_cls.theme_style = 'Dark'

    def build(self):
        self.theme_cls.primary_palette = 'Purple'
        self.theme_cls.primary_hue = '500'
        return Builder.load_file('app/pomodoro.kv')
