
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.СписокПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
	
&НаКлиенте
Процедура КомандаСоздатьФормуВвода(Команда)
	
	МассивСтрок = Элементы.Список.ВыделенныеСтроки;
	
	Для каждого ТекНастройка Из МассивСтрок Цикл
	
		 Если НЕ ПроверитьГруппу(ТекНастройка) Тогда
		 
		 	// Создаем новую ФВБ.
			бит_РаботаСДиалогамиКлиент.ОткрытьНовуюФормуВводаБюджета(ТекНастройка);
			
			Прервать;
		 
		 КонецЕсли; 
	
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция проверяет является ли выбранный элемент группой.
//
// Параметры:
//    ТекНастройка - СправочникСсылка.бит_НастройкиВнешнихПодключений
//
// Возвращаемое значение:
//  флЭтоГруппа - Булево.
//
&НаСервереБезКонтекста
Функция ПроверитьГруппу(ТекНастройка)

	флЭтоГруппа = ТекНастройка.ЭтоГруппа;

	Возврат флЭтоГруппа;
	
КонецФункции

#КонецОбласти
