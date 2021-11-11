﻿
#Область ОписаниеПеременных

// Хранит флаг автоматического формирования наименования.
&НаКлиенте
Перем мФормироватьНаименованиеПолноеАвтоматически;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МетаданныеОбъекта = Объект.Ссылка.Метаданные();
	
    Если фОтказ Тогда
		Возврат;
	КонецЕсли;
	
	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);

	
	// Выведем установленный заголовок.
    бит_НазначениеСинонимовОбъектов.ВывестиЗаголовокФормы(МетаданныеОбъекта
														 , ЭтаФорма
														 , Перечисления.бит_ВидыФормОбъекта.Элемента
														 , Объект);
														 
	Элементы.Код.Маска = РегистрыСведений.бит_МаскиКодов.ПолучитьМаскуКодаПланаСчетов(МетаданныеОбъекта.Имя);
	
	// Установить видимость реквизитов и заголовков колонок.
	УправлениеЭлементамиФормы();
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если фОтказ Тогда
		Отказ = Истина;
		Возврат;	
	КонецЕсли;
	
	// Установим значение переменной "мФормироватьНаименованиеПолноеАвтоматически".
    УстановитьФлагФормироватьНаименованиеПолноеАвтоматически();
	
КонецПроцедуры // ПриОткрытии()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КодПриИзменении(Элемент)
	
	// По умолчанию код быстрого выбора - код.
	Объект.КодБыстрогоВыбора = бит_БухгалтерияКлиентСервер.ПолучитьКодБыстрогоДоступа(Объект.Код);
	
КонецПроцедуры // КодПриИзменении()

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Если мФормироватьНаименованиеПолноеАвтоматически Тогда
		Объект.НаименованиеПолное = Объект.Наименование;
	КонецЕсли;
	
КонецПроцедуры // НаименованиеПриИзменении()

&НаКлиенте
Процедура НаименованиеПолноеПриИзменении(Элемент)
	
	УстановитьФлагФормироватьНаименованиеПолноеАвтоматически();
	
КонецПроцедуры // НаименованиеПолноеПриИзменении()

&НаКлиенте
Процедура НаименованиеПолноеАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	Если Ожидание = 0 Тогда
	
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.Добавить(Объект.Наименование);
	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютныйПриИзменении(Элемент)
	
	 ИзменениеПризнака(Элемент.Имя);
	
КонецПроцедуры // ВалютныйПриИзменении()

&НаКлиенте
Процедура КоличественныйПриИзменении(Элемент)
	
	ИзменениеПризнака(Элемент.Имя);
	
КонецПроцедуры // КоличественныйПриИзменении()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВидыСубконто

&НаКлиенте
Процедура ВидыСубконтоПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущиеДанные = Элементы.ВидыСубконто.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НоваяСтрока Тогда

		ТекущиеДанные.Суммовой       = Истина;
		ТекущиеДанные.Валютный       = Объект.Валютный;
		ТекущиеДанные.Количественный = Объект.Количественный;

	КонецЕсли;
	
КонецПроцедуры // ВидыСубконтоПриНачалеРедактирования()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура проверяет, совпадало ли ранее полное наименование с наименованием,
// и присваивает соответствующее значение переменной мФормироватьНаименованиеПолноеАвтоматически.
// 
// Параметры:
//  Нет.
// 
&НаКлиенте
Процедура УстановитьФлагФормироватьНаименованиеПолноеАвтоматически()

	Если ПустаяСтрока(Объект.НаименованиеПолное) 
	 ИЛИ Объект.НаименованиеПолное = Объект.Наименование Тогда
		мФормироватьНаименованиеПолноеАвтоматически = Истина;

	Иначе
		мФормироватьНаименованиеПолноеАвтоматически = Ложь;

	КонецЕсли;

КонецПроцедуры // УстановитьФлагФормироватьНаименованиеПолноеАвтоматически()

// Процедура осуществляет управление видимостью/доступностью элементов управления формы.
// 
// Параметры:
//  Нет.
// 
&НаСервере
Процедура УправлениеЭлементамиФормы()

    Элементы.ВидыСубконтоВалютный.Видимость       = Объект.Валютный;
	Элементы.ВидыСубконтоКоличественный.Видимость = Объект.Количественный;
    
КонецПроцедуры // УстановитьВидимость()

// Процедура обрабатывает изменение признака счета.
// 
// Параметры:
//  ИмяПризнака - Строка
// 
&НаСервере
Процедура ИзменениеПризнака(ИмяПризнака)

	ЗначениеПризнакаСчета = Объект[ИмяПризнака];
	
	Элементы["ВидыСубконто" + ИмяПризнака].Видимость = ЗначениеПризнакаСчета;
	
	Для каждого СтрВидСубконто Из Объект.ВидыСубконто Цикл
		СтрВидСубконто[ИмяПризнака] = ЗначениеПризнакаСчета;		
	КонецЦикла;

КонецПроцедуры // ИзменениеПризнака()

#КонецОбласти

