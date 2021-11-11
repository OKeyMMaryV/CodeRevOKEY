﻿
&НаСервере
Процедура СформироватьНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	бит_му_НастройкиРасчетаОтложенныхНалогов.Период,
	|	бит_му_НастройкиРасчетаОтложенныхНалогов.Организация,
	|	бит_му_НастройкиРасчетаОтложенныхНалогов.ВидАктивовОбязательств,
	|	бит_му_НастройкиРасчетаОтложенныхНалогов.ИсточникДанных,
	|	бит_му_НастройкиРасчетаОтложенныхНалогов.ТипНастройки,
	|	бит_му_НастройкиРасчетаОтложенныхНалогов.ВидАктивовОбязательствДляРекласса,
	|	бит_му_НастройкиРасчетаОтложенныхНалогов.ИсточникДанныхДляВычета
	|ИЗ
	|	РегистрСведений.бит_му_НастройкиРасчетаОтложенныхНалогов КАК бит_му_НастройкиРасчетаОтложенныхНалогов";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ТаблицаЗначений = Новый ТаблицаЗначений;
	
	ТаблицаЗначений.Колонки.Добавить("Период");
	ТаблицаЗначений.Колонки.Добавить("Организация");
	ТаблицаЗначений.Колонки.Добавить("ВидАктивовОбязательств");
	ТаблицаЗначений.Колонки.Добавить("ИсточникДанных");
	ТаблицаЗначений.Колонки.Добавить("ТипНастройки");
	ТаблицаЗначений.Колонки.Добавить("ВидАктивовОбязательствДляРекласса");
	ТаблицаЗначений.Колонки.Добавить("ИсточникДанныхДляВычета");
	
	
	
	ТаблицаЗначений.Колонки.Добавить("Отбор");
	ТаблицаЗначений.Колонки.Добавить("Использование");
	ТаблицаЗначений.Колонки.Добавить("ВидСравнения");
	ТаблицаЗначений.Колонки.Добавить("Значение");
	
	ТаблицаЗначенийСоСчетами = ТаблицаЗначений.Скопировать();
	ТаблицаЗначенийСоСчетами.Колонки.Добавить("СчетНУ");
	ТаблицаЗначенийСоСчетами.Колонки.Добавить("СчетМУ");
	
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Источник = ВыборкаДетальныеЗаписи.ИсточникДанных.ПолучитьОбъект();
		СтруктураНастроек = Источник.ПолучитьНастройкиИсточника();
		МассивСОтборами = СтруктураНастроек.Отбор;
		
		МассивМУ = Новый Массив;
		МассивНУ = Новый Массив;
		
		Для Каждого Эл из МассивСОтборами Цикл
			Если Эл.ПутьКДанным = "СчетМУ" Тогда											
				Если ТипЗнч(Эл.Значение) = Тип("СписокЗначений") Тогда
					Для Каждого СтрСп из Эл.Значение Цикл							
						МассивМУ.Добавить(СтрСп.Значение);
					КонецЦикла;
				Иначе
						МассивМУ.Добавить(Эл.Значение);					
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;		
		
		Для Каждого Эл из МассивСОтборами Цикл
			Если Эл.ПутьКДанным = "СчетНУ" Тогда												
				Если ТипЗнч(Эл.Значение) = Тип("СписокЗначений") Тогда
					Для Каждого СтрСп из Эл.Значение Цикл							
						МассивНУ.Добавить(СтрСп.Значение);
					КонецЦикла;
				Иначе
					МассивНУ.Добавить(Эл.Значение);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
				
		Для Каждого Эл из МассивСОтборами Цикл 						
			Для Каждого Стр Из МассивМУ Цикл
				Строка = ТаблицаЗначенийСоСчетами.Добавить();
				ЗаполнитьЗначенияСвойств(Строка,ВыборкаДетальныеЗаписи);
				Строка.СчетМУ = Стр;
				
				Если МассивНУ.Количество() Тогда
					Строка.СчетНУ = МассивНУ[0];					
				КонецЕсли;
				
				
				Строка.Отбор =  Эл.Представление;
				Строка.Использование = Эл.Использование;
				Строка.ВидСравнения = Эл.ВидСравнения;
				Строка.Значение =  Эл.Значение;	
				
				Если ТипЗнч(Строка.Значение) = Тип("СписокЗначений") Тогда
					
					Строка.Значение = "";
					
					Для Каждого СтрСп из Эл.Значение Цикл							
						Строка.Значение = Строка.Значение + СтрСп.Значение + "; ";
					КонецЦикла;
					
				КонецЕсли;
				
			КонецЦикла;
		КонецЦикла;	
		
		Для Каждого Эл из МассивСОтборами Цикл 							
			Для Каждого Стр Из МассивНУ Цикл
				Строка = ТаблицаЗначенийСоСчетами.Добавить();
				ЗаполнитьЗначенияСвойств(Строка,ВыборкаДетальныеЗаписи);
				Строка.СчетНУ = Стр;
				
				Строка.Отбор =  Эл.Представление;
				Строка.Использование = Эл.Использование;
				Строка.ВидСравнения = Эл.ВидСравнения;
				Строка.Значение =  Эл.Значение;	
				
				Если МассивМУ.Количество() Тогда
					Строка.СчетМУ = МассивМУ[0];					
				КонецЕсли;
				
				
				
				Если ТипЗнч(Строка.Значение) = Тип("СписокЗначений") Тогда
					
					Строка.Значение = "";
					
					Для Каждого СтрСп из Эл.Значение Цикл							
						Строка.Значение = Строка.Значение + СтрСп.Значение + "; ";
					КонецЦикла;
					
				КонецЕсли;

			КонецЦикла;
		КонецЦикла;	
		
	КонецЦикла;
	
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("Таблица", ТаблицаЗначенийСоСчетами);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Обработки.бит_ОтчетПоИсточникамДанных.ПолучитьМакет("Макет"), Компоновщик.Настройки, , ,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));	
	
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных);
	
    ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
    ТаблицаЗначенийИзСКД = Новый ТаблицаЗначений;
	ПроцессорВывода.УстановитьОбъект(ТаблицаЗначенийИзСКД);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);	
	
	Для Каждого СтрокаСКД Из ТаблицаЗначенийИзСКД Цикл
		
		Источник = СтрокаСКД.ИсточникДанных.ПолучитьОбъект();
		СтруктураНастроек = Источник.ПолучитьНастройкиИсточника();
		МассивСОтборами = СтруктураНастроек.Отбор;
		
		Для Каждого Эл из МассивСОтборами Цикл 			
			Строка = ТаблицаЗначений.Добавить();
			ЗаполнитьЗначенияСвойств(Строка,СтрокаСКД);		
			Строка.Отбор =  Эл.Представление;
			Строка.Использование = Эл.Использование;
			Строка.ВидСравнения = Эл.ВидСравнения;
			Строка.Значение =  Эл.Значение;	
			
			Если ТипЗнч(Строка.Значение) = Тип("СписокЗначений") Тогда
				
				Строка.Значение = "";
				
				Для Каждого СтрСп из Эл.Значение Цикл							
					Строка.Значение = Строка.Значение + СтрСп.Значение + "; ";
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЦикла;

		
		
	КонецЦикла;
	
	
	Объект.Отборы.Загрузить(ТаблицаЗначений);	
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ТЗ.ВидАктивовОбязательств,
	|	ТЗ.ИсточникДанных,
	|	ТЗ.ТипНастройки,
	|	ТЗ.ВидАктивовОбязательствДляРекласса,
	|	ТЗ.Период,
	|	ТЗ.Организация,
	|	ТЗ.Отбор,
	|	ТЗ.ВидСравнения,
	|	ТЗ.Использование,
	|	ТЗ.Значение,
	|	ТЗ.ИсточникДанныхДляВычета
	|ПОМЕСТИТЬ ВТ
	|ИЗ
	|	&ТЗ КАК ТЗ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ.ВидАктивовОбязательств КАК ВидАктивовОбязательств,
	|	ВТ.ИсточникДанных КАК ИсточникДанных,
	|	ВТ.ТипНастройки КАК ТипНастройки,
	|	ВТ.ВидАктивовОбязательствДляРекласса КАК ВидАктивовОбязательствДляРекласса,
	|	ВТ.Период,
	|	ВТ.Организация,
	|	ВТ.Отбор,
	|	ВТ.ВидСравнения,
	|	ВТ.Использование,
	|	ВТ.Значение,
	|	ВТ.ИсточникДанныхДляВычета КАК ИсточникДанныхДляВычета
	|ИЗ
	|	ВТ КАК ВТ
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ.ВидАктивовОбязательств,
	|	ВТ.ИсточникДанных,
	|	ВТ.ТипНастройки,
	|	ВТ.ВидАктивовОбязательствДляРекласса,
	|	ВТ.ИсточникДанныхДляВычета,
	|	ВТ.Период,
	|	ВТ.Организация,
	|	ВТ.Отбор,
	|	ВТ.ВидСравнения,
	|	ВТ.Использование,
	|	ВТ.Значение
	|ИТОГИ ПО
	|	ТипНастройки,
	|	ВидАктивовОбязательств,
	|	ИсточникДанных");
	Запрос.УстановитьПараметр("ТЗ",Объект.Отборы.Выгрузить());
	
	ЗначениеВРеквизитФормы(Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам),"ДеревоПоИсточникам");
		
	
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	СформироватьНаСервере();
КонецПроцедуры


&НаКлиенте
Процедура ПоказатьУровеньДерева(чНужныйУровеньДерева)

    спзСтрокиДереваДляСортировки = Новый СписокЗначений;
    ЭлементыДерева = ДеревоПоИсточникам.ПолучитьЭлементы();
    РазобратьДеревоПоИсточникамНаСтроки(ЭлементыДерева, 0, спзСтрокиДереваДляСортировки);

    СвернутьСтрокиДереваДокументов(спзСтрокиДереваДляСортировки, чНужныйУровеньДерева);

КонецПроцедуры


// В связи с особенностью сворачивания дерева на форме, сворачивать можно только от самых нижних уровней.

// Дерево значений разбиваем на строки, сортируем и начинаем сворачивать от самого нижнего уровня.
// Данный подход позволяет реализовать на клиенте метод Уровень() Дерева значений, доступный только на сервере.
&НаКлиенте
Процедура РазобратьДеревоПоИсточникамНаСтроки(ЭлементыДерева, чПредУровень, спзСтрокиДереваДляСортировки)

    чТекУровень = чПредУровень + 1;

    Для Каждого СтрокаДерева Из ЭлементыДерева Цикл
        спзСтрокиДереваДляСортировки.Добавить(чТекУровень, СтрокаДерева.ПолучитьИдентификатор());
        ПодчиненныеЭлементыДерева  = ДеревоПоИсточникам.НайтиПоИдентификатору(СтрокаДерева.ПолучитьИдентификатор()).ПолучитьЭлементы();
        РазобратьДеревоПоИсточникамНаСтроки(ПодчиненныеЭлементыДерева, чПредУровень + 1, спзСтрокиДереваДляСортировки);
    КонецЦикла;

КонецПроцедуры
// Сортировка, свертка от нижнего уровня. Раскрытие до нужного уровня.

&НаКлиенте
Процедура СвернутьСтрокиДереваДокументов(спзСтрокиДереваДляСортировки, чНужныйУровеньДерева)

    спзСтрокиДереваДляСортировки.СортироватьПоЗначению(НаправлениеСортировки.Убыв);

    Для каждого ТекСтрокаспзСтрокиДереваДляСортировки из спзСтрокиДереваДляСортировки Цикл
        Элементы.ДеревоПоИсточникам.Свернуть(ТекСтрокаспзСтрокиДереваДляСортировки.Представление);
    КонецЦикла;

    Для каждого ТекСтрокаспзСтрокиДереваДляСортировки из спзСтрокиДереваДляСортировки Цикл
        Если ТекСтрокаспзСтрокиДереваДляСортировки.Значение <= чНужныйУровеньДерева тогда
            Элементы.ДеревоПоИсточникам.Развернуть(ТекСтрокаспзСтрокиДереваДляСортировки.Представление);
        КонецЕсли;
    КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура Уровень1(Команда)
    ПоказатьУровеньДерева(0);
КонецПроцедуры

&НаКлиенте
Процедура Уровень2(Команда)
    ПоказатьУровеньДерева(1);
КонецПроцедуры

&НаКлиенте
Процедура Уровень3(Команда)
    ПоказатьУровеньДерева(2);
КонецПроцедуры

&НаКлиенте
Процедура Уровень4(Команда)
    ПоказатьУровеньДерева(3);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	
	СхемаКомпоновкиДанных = Обработки.бит_ОтчетПоИсточникамДанных.ПолучитьМакет("Макет");
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных);
	
	
	Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных));
	
	Компоновщик.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	Компоновщик.Восстановить();

	
КонецПроцедуры
