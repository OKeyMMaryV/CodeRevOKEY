﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	// Выполняется только при закрытии формы
	ЗаписатьНаСервере();
	Отказ = Истина;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеИспользоватьПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ПредставленияОснованийУвольненияПредставлениеИспользоватьПриИзменении(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьНаКлиенте(Команда)
	ЗаписатьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрытьНаКлиенте(Команда)
	
	ЗаписатьНаСервере();
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект)
	ЗарплатаКадры.ПредставленияОснованийУвольненияПриПолученииДанныхНаСервере(ЭтотОбъект, ТекущийОбъект);
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНаСервере()
	ЗарплатаКадры.ПредставленияОснованийУвольненияЗаписатьНаСервере(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти
