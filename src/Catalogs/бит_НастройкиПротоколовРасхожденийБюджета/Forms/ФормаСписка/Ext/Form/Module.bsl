﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

  	// Стандартные действия при создании на сервере.
  	бит_РаботаСДиалогамиСервер.СписокПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти 

#Область ОбработчикиКомандФормы
	
&НаКлиенте
Процедура СоздатьДокументПротоколРасхожденийБюджета(Команда)
	
	МассивСтрок = Элементы.Список.ВыделенныеСтроки;
	
	Для каждого ТекСсылка Из МассивСтрок Цикл
	
		  Если ЗначениеЗаполнено(ТекСсылка) И НЕ ПроверитьЭтоГруппа(ТекСсылка) Тогда
		 
		 	// Создаем новую форму документа.
			бит_РаботаСДиалогамиКлиент.ОткрытьНовуюФормуДокументаПротоколРасхожденийБюджета(ТекСсылка);
			
			Прервать;
		 
		 КонецЕсли; 
	
	КонецЦикла; 
	
КонецПроцедуры // СоздатьДокументПротоколРасхожденийБюджета()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПроверитьЭтоГруппа(ТекСсылка)

	флЭтоГруппа = ТекСсылка.ЭтоГруппа;

	Возврат флЭтоГруппа;
	
КонецФункции // ПроверитьЭтоГруппа()

#КонецОбласти

