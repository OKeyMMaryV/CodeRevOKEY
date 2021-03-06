
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаОбъектаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
	
	//ОКЕЙ Рычаков А.С.(СофтЛаб)2019-10-07 Начало (#3499)
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	//ОКЕЙ Рычаков А.С.(СофтЛаб)2019-10-07 Конец (#3499)
	 

КонецПроцедуры // ПриСозданииНаСервере()

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	 Если НЕ ТекущийОбъект.ЭтоГруппа Тогда
	 
		 Запрос = Новый Запрос;
		 Запрос.УстановитьПараметр("ВидРешения",ТекущийОбъект.Ссылка);
		 Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
		                |	бит_НазначениеВидовРешенийСогласования.ВидРешения
		                |ИЗ
		                |	РегистрСведений.бит_НазначениеВидовРешенийСогласования КАК бит_НазначениеВидовРешенийСогласования
		                |ГДЕ
		                |	бит_НазначениеВидовРешенийСогласования.ВидРешения = &ВидРешения";
						
		Результат = Запрос.Выполнить();
		
		Если Результат.Пустой() Тогда
		
			МенеджерЗаписи = РегистрыСведений.бит_НазначениеВидовРешенийСогласования.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ВидРешения = ТекущийОбъект.Ссылка;
			Попытка
			
				МенеджерЗаписи.Записать();
			
			Исключение
			
			КонецПопытки;
		
		КонецЕсли; 
			 
	 КонецЕсли; 
	
 КонецПроцедуры // ПослеЗаписиНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	//ОКЕЙ Рычаков А.С.(СофтЛаб)2019-10-07 Начало (#3499)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	//ОКЕЙ Рычаков А.С.(СофтЛаб)2019-10-07 Конец (#3499)

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	//ОКЕЙ Рычаков А.С.(СофтЛаб)2019-10-07 Начало (#3499)
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	//ОКЕЙ Рычаков А.С.(СофтЛаб)2019-10-07 Конец (#3499)
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	//ОКЕЙ Рычаков А.С.(СофтЛаб)2019-10-07 Начало (#3499)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	//ОКЕЙ Рычаков А.С.(СофтЛаб)2019-10-07 Конец (#3499)
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	//ОКЕЙ Рычаков А.С.(СофтЛаб)2019-10-07 Начало (#3499)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	//ОКЕЙ Рычаков А.С.(СофтЛаб)2019-10-07 Конец (#3499)
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	//ОКЕЙ Рычаков А.С.(СофтЛаб)2019-10-07 Начало (#3499)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	//ОКЕЙ Рычаков А.С.(СофтЛаб)2019-10-07 Конец (#3499)
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//ОКЕЙ Рычаков А.С.(СофтЛаб)2019-10-07 Начало (#3499)
// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
    УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
    УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
    УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства
//ОКЕЙ Рычаков А.С.(СофтЛаб)2019-10-07 Конец (#3499)

#КонецОбласти