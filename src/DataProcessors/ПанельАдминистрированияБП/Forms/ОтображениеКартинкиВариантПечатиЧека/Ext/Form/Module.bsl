﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено(Параметры.ИмяКартинки) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Элементы.Вариант.Картинка = БиблиотекаКартинок[Параметры.ИмяКартинки];
КонецПроцедуры
