﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Режим открытия	
	Перем Режим;
    // Вид информационной базы
    Перем ВидИнформационнойБазы;  
	// Настройка подключения к информационной базе.
	Перем ИнформационнаяБаза;  
	// Имя объекта обмена
	Перем ИмяОбъекта;
	// Вид объекта обмена
	Перем ВидОбъектаСтр;
	
	бит_РаботаСДиалогамиСервер.СписокПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма);

	Параметры.Свойство("Режим", Режим);
	Параметры.Свойство("ВидИнформационнойБазы", ВидИнформационнойБазы);
	Параметры.Свойство("ИнформационнаяБаза", ИнформационнаяБаза);
	Параметры.Свойство("Имя", ИмяОбъекта);
	Параметры.Свойство("Вид", ВидОбъектаСтр);
	
	Если ВРег(Режим) = ВРег("СписокОбъектов") Тогда
	
		Если ЗначениеЗаполнено(ИнформационнаяБаза) Тогда
		
			 ВидИнформационнойБазы = ИнформационнаяБаза.ВидИнформационнойБазы;
			 
		 Иначе
			 
			 ИнформационнаяБаза = Справочники.бит_мпд_НастройкиВнешнихПодключений.ПустаяСсылка();
		
		КонецЕсли; 
		
		ВидОбъекта = Перечисления.бит_мдм_ВидыОбъектовОбмена[ВидОбъектаСтр];
		ОписаниеОбъекта = Справочники.бит_мдм_ОписанияОбъектовОбмена.НайтиЭлемент(ВидИнформационнойБазы, ВидОбъекта, ИмяОбъекта);
		
		// Устнавливаем отбор для конкретной базы и описания объекта.
		
		эо = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		эо.Использование  = Истина;
		эо.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ВидИнформационнойБазы");
		эо.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		эо.ПравоеЗначение = ВидИнформационнойБазы;
		эо.Применение     = ТипПримененияОтбораКомпоновкиДанных.Иерархия;
		
		эо = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		эо.Использование  = Истина;
		эо.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ИнформационнаяБаза");
		эо.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		эо.ПравоеЗначение = ИнформационнаяБаза;
		эо.Применение     = ТипПримененияОтбораКомпоновкиДанных.Иерархия;
		
		эо = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		эо.Использование  = Истина;
		эо.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ОписаниеОбъекта");
		эо.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		эо.ПравоеЗначение = ОписаниеОбъекта;
		эо.Применение     = ТипПримененияОтбораКомпоновкиДанных.Иерархия;
		
		ЭтотОбъект.Заголовок = ОписаниеОбъекта.Наименование;
		
	КонецЕсли; 	
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти
