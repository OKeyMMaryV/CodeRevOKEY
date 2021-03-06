#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.бит_му_НастройкиРасчетаОтложенныхНалогов;
	
	// Вызов механизма защиты
	
	
	бит_РаботаСДиалогамиСервер.ФормаЗаписиРегистраПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект);

	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьКэшЗначений();
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет кэш значений.
// 
// Параметры:
//  Нет
// 
&НаСервере
Процедура ЗаполнитьКэшЗначений()

	фКэшЗначений = Новый Структура;

	фКэшЗначений.Вставить("ТипОтложенныеНалогиМСФО", Перечисления.бит_ТипыИсточниковДанных.ОтложенныеНалогиМСФО);
	
	//bit Amerkulov 20.11.2014 ++ Расчет отложенных налогов
	СписокДополнительныхТиповМСФО = Новый СписокЗначений;
	СписокДополнительныхТиповМСФО.Добавить(Перечисления.бит_ТипыИсточниковДанных.бит_МСФО_ОтложенныеНалогиКорректировкиОборотыМУ);
	СписокДополнительныхТиповМСФО.Добавить(Перечисления.бит_ТипыИсточниковДанных.бит_МСФО_ОтложенныеНалогиКорректировкиОстаткиБУ);
	СписокДополнительныхТиповМСФО.Добавить(Перечисления.бит_ТипыИсточниковДанных.бит_МСФО_ОтложенныеНалогиКорректировкиОстаткиМУ);
	фКэшЗначений.Вставить("СписокДополнительныхТиповМСФО",СписокДополнительныхТиповМСФО);
	//bit Amerkulov 20.11.2014 -- Расчет отложенных налогов
	
КонецПроцедуры // ЗаполнитьКэшЗначений()

// Процедура - обработчик события "НачалоВыбора" поля ввода "ИсточникДанных". 
// 
&НаКлиенте
Процедура ИсточникДанныхНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Отбор = Новый Структура("ТипИсточника", фКэшЗначений.ТипОтложенныеНалогиМСФО);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Отбор);
	ПараметрыФормы.Вставить("ТекущийЭлемент", Запись.ИсточникДанных);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Истина);
	
	ОткрытьФорму("Справочник.бит_ИсточникиДанных.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры // ИсточникДанныхНачалоВыбора()

//bit Amerkulov 20.11.2014 ++ Расчет отложенных налогов
&НаКлиенте
Процедура УстановитьДоступностьЭлементов()
	
	Если Запись.ТипНастройки <> ПредопределенноеЗначение("Перечисление.бит_РОН_ТипыНастройкиРасчетаОтложенныхНалоговМСФО.БалансовыеКорректировки") Тогда
		
		Элементы.ВидАктивовОбязательствДляРекласса.Доступность = Ложь;
		
		Если ЗначениеЗаполнено(Запись.ВидАктивовОбязательствДляРекласса) Тогда			
			Запись.ВидАктивовОбязательствДляРекласса = Неопределено;
		КонецЕсли;
		
	Иначе
		Элементы.ВидАктивовОбязательствДляРекласса.Доступность = Истина;		
	КонецЕсли;
	
	Если Запись.ТипНастройки = ПредопределенноеЗначение("Перечисление.бит_РОН_ТипыНастройкиРасчетаОтложенныхНалоговМСФО.НалоговаяБалансоваяБаза") Тогда
		
		Элементы.ИсточникДанныхДляВычета.Доступность = Ложь;
		
		Если ЗначениеЗаполнено(Запись.ИсточникДанныхДляВычета) Тогда			
			Запись.ИсточникДанныхДляВычета = Неопределено;
		КонецЕсли;
		
	Иначе
		Элементы.ИсточникДанныхДляВычета.Доступность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипНастройкиПриИзменении(Элемент)
	УстановитьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ИсточникДанныхДляВычетаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;	
	
	Если Не ЗначениеЗаполнено(Запись.ТипНастройки) Тогда
		Сообщить("Сначала выберите тип настройки!");
		СтандартнаяОбработка = Ложь;		
		Возврат;
	КонецЕсли;
	
	
	Отбор = Новый Структура("ТипИсточника", фКэшЗначений.СписокДополнительныхТиповМСФО);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Отбор);
	ПараметрыФормы.Вставить("ТекущийЭлемент", Запись.ИсточникДанных);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Истина);
		
	ОткрытьФормуМодально("Справочник.бит_ИсточникиДанных.Форма.ФормаВыбораУправляемая", ПараметрыФормы, Элемент);
		
КонецПроцедуры

// Процедура - обработчик события "ПередЗаписью" формы. 
//
&НаКлиенте
Процедура ПередЗаписью(Отказ)
	
	ПроверитьВозможностьЗаписи(Отказ);
	
	Если Отказ Тогда
		
		ТекстСообщения = Нстр("ru = 'Запись с такими ключевыми полями существует.'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
					
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

// Процедура проверяет возможность записи
//
&НаСервере
Процедура ПроверитьВозможностьЗаписи(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Период"			, Запись.Период);
	Запрос.УстановитьПараметр("Организация"		, Запись.Организация);
	Запрос.УстановитьПараметр("ВидАО"			, Запись.ВидАктивовОбязательств);
	Запрос.УстановитьПараметр("ИсточникДанных"	, Запись.ИсточникДанных);
	//bit Amerkulov 20.11.2014 ++ Расчет отложенных налогов
	Запрос.УстановитьПараметр("ИсточникДанныхДляВычета"				, Запись.ИсточникДанныхДляВычета);
	Запрос.УстановитьПараметр("ВидАктивовОбязательствДляРекласса"	, Запись.ВидАктивовОбязательствДляРекласса);
	Запрос.УстановитьПараметр("ТипНастройки"						, Запись.ТипНастройки);		
	//bit Amerkulov 20.11.2014 -- Расчет отложенных налогов
	Запрос.Текст = "
	|ВЫБРАТЬ
    |	Настройки.ИсточникДанных
    |ИЗ
    |	РегистрСведений.бит_му_НастройкиРасчетаОтложенныхНалогов КАК Настройки
    |ГДЕ
    |	Настройки.Период 					= &Период
    |	И Настройки.Организация 			= &Организация
    |	И Настройки.ВидАктивовОбязательств 	= &ВидАО
    |	И Настройки.ИсточникДанных 			= &ИсточникДанных
	//bit Amerkulov 20.11.2014 ++ Расчет отложенных налогов
    |	И Настройки.ИсточникДанныхДляВычета 			= &ИсточникДанныхДляВычета
    |	И Настройки.ВидАктивовОбязательствДляРекласса 	= &ВидАктивовОбязательствДляРекласса
    |	И Настройки.ТипНастройки 			= &ТипНастройки	
	//bit Amerkulov 20.11.2014 -- Расчет отложенных налогов	
	|";
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
	
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры // ПроверитьВозможностьЗаписи()
//bit Amerkulov 20.11.2014 -- Расчет отложенных налогов

#КонецОбласти

