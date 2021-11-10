﻿//2011-11-25
Процедура СнятьФлаги() Экспорт 

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	бит_ок_НастройкиМеханизмаИмпортаДанных.Значение
	               |ПОМЕСТИТЬ ВТ_НеСопоставлено
	               |ИЗ
	               |	РегистрСведений.бит_ок_НастройкиМеханизмаИмпортаДанных КАК бит_ок_НастройкиМеханизмаИмпортаДанных
	               |ГДЕ
	               |	бит_ок_НастройкиМеханизмаИмпортаДанных.Группа = ""Служебные элементы Не сопоставлено""
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	бит_ок_ОперацияАксапты.Ссылка
	               |ПОМЕСТИТЬ ВТ_Документы
	               |ИЗ
	               |	Документ.бит_ок_ОперацияАксапты КАК бит_ок_ОперацияАксапты
	               |ГДЕ
	               |	бит_ок_ОперацияАксапты.Дата МЕЖДУ &НачалоПериода И КОНЕЦПЕРИОДА(&КонецПериода, ДЕНЬ)
	               |	И бит_ок_ОперацияАксапты.ЗагруженоСОшибкой
	               |	И бит_ок_ОперацияАксапты.Организация = &Организация
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ХозрасчетныйСубконто.Регистратор
	               |ПОМЕСТИТЬ ВТ_ДвиженияНеСопоставленные
	               |ИЗ
	               |	РегистрБухгалтерии.Хозрасчетный.Субконто КАК ХозрасчетныйСубконто
	               |ГДЕ
	               |	ХозрасчетныйСубконто.Значение В
	               |			(ВЫБРАТЬ
	               |				ВТ_НеСопоставлено.Значение
	               |			ИЗ
	               |				ВТ_НеСопоставлено)
	               |	И ХозрасчетныйСубконто.Регистратор В
	               |			(ВЫБРАТЬ
	               |				ВТ_Документы.Ссылка
	               |			ИЗ
	               |				ВТ_Документы)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ВТ_Документы.Ссылка КАК Ссылка
	               |ИЗ
	               |	ВТ_Документы КАК ВТ_Документы
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ДвиженияНеСопоставленные КАК ВТ_ДвиженияНеСопоставленные
	               |		ПО ВТ_Документы.Ссылка = ВТ_ДвиженияНеСопоставленные.Регистратор
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный КАК Хозрасчетный
	               |		ПО ВТ_Документы.Ссылка = Хозрасчетный.Регистратор
	               |ГДЕ
	               |	ВТ_ДвиженияНеСопоставленные.Регистратор ЕСТЬ NULL 
	               |	И (НЕ Хозрасчетный.Регистратор ЕСТЬ NULL )
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Ссылка
	               |АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.УстановитьПараметр("НачалоПериода", 	НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", 	КонецПериода);
	Запрос.УстановитьПараметр("Организация", 	Организация);
	
	Результат 				= Запрос.Выполнить();
	Выборка 				= Результат.Выбрать();
	ВсегоДокументов			= Выборка.Количество();
	Инд						= 1;
	
	Пока Выборка.Следующий() Цикл
		ОК_ОбщегоНазначения.ВыводСтатусаСообщения("Обрабатывается документ " + Инд + " из " + ВсегоДокументов,, Истина);
		Инд					= Инд + 1;
	    ДокОбъект			= Выборка.Ссылка.ПолучитьОбъект();
		//ОКЕЙ Рычаков А.С.(СофтЛаб)2019-12-20 Начало (#3587)
		ДокОбъект.ДополнительныеСвойства.Вставить("НеПроверятьНаличиеЗнРДСдляДокументовФакта",Истина);
		//ОКЕЙ Рычаков А.С.(СофтЛаб)2019-12-20 Конец (#3587)
		ДокОбъект.ЗагруженоСОшибкой = Ложь;
	    ДокОбъект.Записать();
	КонецЦикла;
	

КонецПроцедуры

Процедура ОпределитьНастройку(ТЗНастройки, ИмяНастройки, Параметр)
	
	НайденнаяСтрока			= ТЗНастройки.Найти(ИмяНастройки);
	Если НайденнаяСтрока = Неопределено Тогда 
		Сообщение			= "В Настройках механизма импорта данных не найдена настройка " + ИмяНастройки;
		ОК_ОбщегоНазначения.ВыводСтатусаСообщения(, Сообщение);		
		СделатьЗаписьЖР(Сообщение);
		Отказ				= Истина;
	Иначе
		Параметр			= НайденнаяСтрока.Значение;
	КонецЕсли;
	
	
КонецПроцедуры

Процедура СделатьЗаписьЖР(Сообщение)

	#Если Сервер Тогда
		ЗаписьЖурналаРегистрации("Объект в сторно закупок. Обработка" 
		,УровеньЖурналаРегистрации.Информация 
		,
		,
		,Сообщение);
	#КонецЕсли 

КонецПроцедуры


Процедура ЗаполнитьНастройки()

	Запрос = Новый Запрос;
		
	Запрос.Текст			= "ВЫБРАТЬ
	|	бит_ок_НастройкиМеханизмаИмпортаДанных.Группа,
	|	бит_ок_НастройкиМеханизмаИмпортаДанных.ИмяНастройки,
	|	бит_ок_НастройкиМеханизмаИмпортаДанных.Значение
	|ИЗ
	|	РегистрСведений.бит_ок_НастройкиМеханизмаИмпортаДанных КАК бит_ок_НастройкиМеханизмаИмпортаДанных
	|ГДЕ
	|	бит_ок_НастройкиМеханизмаИмпортаДанных.Группа В(&СписокНастроек)";
	
	СписокНастроек			= Новый Массив;
	СписокНастроек.Добавить("ПараметрыЗагрузкиАксапты");
	СписокНастроек.Добавить("Организации");
	Запрос.УстановитьПараметр("СписокНастроек", СписокНастроек);
	
	ТЗНастройки 			= Запрос.Выполнить().Выгрузить();
	
	Отказ					= Ложь;
	ОпределитьНастройку(ТЗНастройки, "Начало Периода Лоджистикс", НачалоПериода);
	ОпределитьНастройку(ТЗНастройки, "Конец Периода Лоджистикс", КонецПериода);
	ОпределитьНастройку(ТЗНастройки, "Организация Лоджистикс", Организация);
	
КонецПроцедуры

ЗаполнитьНастройки()