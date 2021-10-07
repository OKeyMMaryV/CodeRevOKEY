﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПерезаполнитьНормы   = Параметры.СпроситьОНормах;
	ПерезаполнитьПериоды = Параметры.ИзменитсяПериодичность;
	ПересчитатьСуммы     = Параметры.ИзменитсяВалюта;	
			
	Элементы.ПерезаполнитьНормы.Видимость   = ПерезаполнитьНормы;
	Элементы.ПерезаполнитьПериоды.Видимость = ПерезаполнитьПериоды;
	Элементы.ПересчитатьСуммы.Видимость     = ПересчитатьСуммы;
	               	       		
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	РезСтр = Новый Структура("ПерезаполнитьНормы, ПерезаполнитьПериоды, ПересчитатьСуммы"
							, ПерезаполнитьНормы, ПерезаполнитьПериоды, ПересчитатьСуммы);
	Закрыть(РезСтр);
	
КонецПроцедуры // КомандаОК()

#КонецОбласти
