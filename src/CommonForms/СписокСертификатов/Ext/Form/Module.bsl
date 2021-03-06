#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Отпечаток = Параметры.Отпечаток;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Оповещение = Новый ОписаниеОповещения("ПослеПолученияСпискаСертификатов", ЭтотОбъект);
	КриптографияЭДКОКлиент.ПолучитьСертификаты(Оповещение, Новый Структура("Хранилище, ЭтоЛокальноеХранилище", "MY", Истина));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСертификаты

&НаКлиенте
Процедура СертификатыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "СертификатыОткрытьСертификат" Тогда
		КриптографияЭДКОКлиент.ПоказатьСертификат(
			Новый Структура("Отпечаток", Сертификаты.НайтиПоИдентификатору(ВыбраннаяСтрока).Отпечаток));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатыВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	Если Элемент.ТекущийЭлемент.Имя <> "СертификатыОткрытьСертификат" Тогда
		Закрыть(Сертификаты.НайтиПоИдентификатору(Значение).Отпечаток);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеПолученияСпискаСертификатов(Результат, ВходящийКонтекст) Экспорт
	
	ТекущаяСтрока = Неопределено;
	ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
	Если Результат.Выполнено Тогда
		Для Каждого Сертификат Из Результат.Сертификаты Цикл
			Если Не Сертификат.ИспользоватьДляПодписи
				ИЛИ Сертификат.ДействителенС > ТекущаяДата ИЛИ Сертификат.ДействителенПо < ТекущаяДата Тогда
				Продолжить;
			КонецЕсли;                            
			
			НоваяСтрока = Сертификаты.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Сертификат);
			
			НоваяСтрока.ОткрытьСертификат = Истина;
			НоваяСтрока.Период = СтрШаблон(
									"%1 - %2", 
									Формат(НоваяСтрока.ДействителенС, "ДЛФ=D"),
									Формат(НоваяСтрока.ДействителенПо, "ДЛФ=D"));
									
			Если Сертификат.Отпечаток = Отпечаток Тогда
				ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
			КонецЕсли;			
		КонецЦикла;
		
		Сертификаты.Сортировать("Наименование Возр, ДействителенПо Убыв"); 
		
		Элементы.Сертификаты.ТекущаяСтрока = ТекущаяСтрока;		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти