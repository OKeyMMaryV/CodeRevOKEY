﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Параметры.Основание) Тогда
		Возврат;
	КонецЕсли;
	
	МетаданныеОснование = Параметры.Основание.Метаданные();
	Для каждого ОбъектМетаданных Из Метаданные.Документы Цикл
		Если ОбъектМетаданных.ВводитсяНаОсновании.Содержит(МетаданныеОснование) 
		   И ПравоДоступа("Изменение", ОбъектМетаданных)
		   И ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(ОбъектМетаданных) Тогда
			ТипыДокументов.Добавить(ОбъектМетаданных.Имя, ОбъектМетаданных.Синоним);
		КонецЕсли;
	КонецЦикла;
	
	Если ТипыДокументов.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'");
		Возврат;
	КонецЕсли;
	
	ТипыДокументов.СортироватьПоПредставлению();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТипыДокументов

&НаКлиенте
Процедура ТипыДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ТипыДокументов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОповеститьОВыборе(ТекущиеДанные.Значение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ТекущиеДанные = Элементы.ТипыДокументов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОповеститьОВыборе(ТекущиеДанные.Значение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Если в списке всего одно значение, то выполняем открытие
	// документа сразу, без списка выбора видов документа.
	#Если НЕ ВебКлиент Тогда
		Если ТипыДокументов.Количество() = 1 Тогда
			ОповеститьОВыборе(ТипыДокументов[0].Значение);
		КонецЕсли;
	#КонецЕсли

КонецПроцедуры

#КонецОбласти
