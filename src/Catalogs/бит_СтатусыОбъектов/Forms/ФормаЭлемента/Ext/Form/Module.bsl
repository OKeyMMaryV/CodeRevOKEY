﻿
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
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьКэшЗначений();
	
	// Восстановим настройки оформления из хранилища.
	Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		СпрОб = Параметры.ЗначениеКопирования.ПолучитьОбъект();
	Иначе	
		СпрОб = РеквизитФормыВЗначение("Объект");
	КонецЕсли; 
	
	НастройкаОформления = СпрОб.ПолучитьОформление();
	Если ТипЗнч(НастройкаОформления) = Тип("Структура") Тогда
		
		бит_ОбщегоНазначения.УстановитьСвойствоИзСтруктуры(ЭтаФорма, НастройкаОформления, "Шрифт"     , "фШрифт");
		бит_ОбщегоНазначения.УстановитьСвойствоИзСтруктуры(ЭтаФорма, НастройкаОформления, "ШрифтАвто" , "фШрифтАвто");
		бит_ОбщегоНазначения.УстановитьСвойствоИзСтруктуры(ЭтаФорма, НастройкаОформления, "ЦветФона"  , "фЦветФона");
		бит_ОбщегоНазначения.УстановитьСвойствоИзСтруктуры(ЭтаФорма, НастройкаОформления, "ЦветТекста", "фЦветТекста");
		
	Иначе
		
		фЦветФона  = Новый Цвет(255,255,255);
		фШрифтАвто = Истина;
		фШрифт 	   = фКэшЗначений.ШрифтАвто;
		
	КонецЕсли; 	
		
КонецПроцедуры 

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Запишем установленное оформление.
	СтруктураОформление = Новый Структура;
	СтруктураОформление.Вставить("Шрифт" 	 , фШрифт);
	СтруктураОформление.Вставить("ШрифтАвто" , фШрифтАвто);
	СтруктураОформление.Вставить("ЦветФона"	 , фЦветФона);
	СтруктураОформление.Вставить("ЦветТекста", фЦветТекста);   	
	
	ТекущийОбъект.СохранитьОформление(СтруктураОформление);  	
	
	//ОКЕЙ Рычаков А.С.(СофтЛаб)2019-10-07 Начало (#3499)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	//ОКЕЙ Рычаков А.С.(СофтЛаб)2019-10-07 Конец (#3499)
	
КонецПроцедуры // ПередЗаписьюНаСервере()

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

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбъектНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидыОбъектов"           , фКэшЗначений.ДоступныеВидыОбъектов);
	ПараметрыФормы.Вставить("ТекущийОбъектСистемы"   , Объект.Объект);
	ПараметрыФормы.Вставить("ДоступныеОбъектыСистемы", фКэшЗначений.ДоступныеОбъектыСистемы);
	
	ОткрытьФорму("ОбщаяФорма.бит_ФормаВыбораОбъектовСистемыУправляемая", ПараметрыФормы, Элемент);
	   	
КонецПроцедуры // ОбъектНачалоВыбора()

&НаКлиенте
Процедура фШрифтПриИзменении(Элемент)
	
	фШрифтАвто = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура фШрифтАвтоПриИзменении(Элемент)
	
	Если фШрифтАвто Тогда
	 	фШрифт = Новый Шрифт;
	Иначе
		фШрифт = фКэшЗначений.ШрифтПоУмолчанию;
	КонецЕсли;
	
КонецПроцедуры // фШрифтАвтоПриИзменении()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет кэш значений доступных на сервере и на клиенте.
// 
&НаСервере
Процедура ЗаполнитьКэшЗначений()

	фКэшЗначений = Новый Структура;	
 
	ДоступныеВидыОбъектов = Новый СписокЗначений;
	ДоступныеВидыОбъектов.Добавить(Перечисления.бит_ВидыОбъектовСистемы.Документ);
	ДоступныеВидыОбъектов.Добавить(Перечисления.бит_ВидыОбъектовСистемы.Задача);
	ДоступныеВидыОбъектов.Добавить(Перечисления.бит_ВидыОбъектовСистемы.БизнесПроцесс);

	фКэшЗначений.Вставить("ДоступныеВидыОбъектов", ДоступныеВидыОбъектов); 

	ДоступныеОбъектыСистемы = бит_Визирование.ВизируемыеОбъектыСистемы();
	ТекОб = Справочники.бит_ОбъектыСистемы.НайтиПоРеквизиту("ИмяОбъектаПолное", "Задача.бит_уп_Задача"); 
	Если ЗначениеЗаполнено(ТекОб) Тогда 	 
		ДоступныеОбъектыСистемы.Добавить(ТекОб);	 
	КонецЕсли;

	ТекОб = Справочники.бит_ОбъектыСистемы.НайтиПоРеквизиту("ИмяОбъектаПолное", "БизнесПроцесс.бит_уп_Процесс"); 
	Если ЗначениеЗаполнено(ТекОб) Тогда 	 
		ДоступныеОбъектыСистемы.Добавить(ТекОб);  	 
	КонецЕсли; 

	фКэшЗначений.Вставить("ДоступныеОбъектыСистемы", ДоступныеОбъектыСистемы);
	фКэшЗначений.Вставить("ШрифтПоУмолчанию"	   , ШрифтыСтиля.ОбычныйШрифтТекста);
	фКэшЗначений.Вставить("ШрифтАвто"	   		   , Новый Шрифт);
	
КонецПроцедуры // ЗаполнитьКэшЗначений()

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