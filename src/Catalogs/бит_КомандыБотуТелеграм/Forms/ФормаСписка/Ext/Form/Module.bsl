﻿
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьКомандыПоУмолчанию(Команда)
	ЗаполнитьКомандыПоУмолчаниюНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьКомандыПоУмолчаниюНаСервере()
	Справочники.бит_КомандыБотуТелеграм.ЗаполнитьКомандыТелеграмПоУмолчанию();
	Элементы.Список.Обновить();
КонецПроцедуры

#КонецОбласти
