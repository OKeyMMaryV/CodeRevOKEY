﻿
&НаКлиенте
Процедура КоманднаяПанель1Отбор(Команда)
	Элементы.Отбор.Пометка = НЕ Элементы.Отбор.Пометка;
	Элементы.КомпоновщикНастроекКомпоновкиДанныхНастройкиОтбор.Видимость = Элементы.Отбор.Пометка;
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеДействияФормыРаспределить(Команда)
	Если ТабличноеПолеРезультат.НайтиСтроки(Новый Структура("Выбран", Истина)).Количество() <> 0 Тогда
		АдресРезультат = Распределить(ТабличноеПолеРезультат);
		ВладелецФормы.бит_БК_ЗагрузитьРезультатыПоискПоБюджету(АдресРезультат);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанель1СнятьФлажки(Команда)
	Для Каждого ТекСтрока ИЗ ТабличноеПолеРезультат Цикл 
		ТекСтрока.Выбран = Ложь;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанель1УстановитьФлажки(Команда)
	Для Каждого ТекСтрока ИЗ ТабличноеПолеРезультат Цикл 
		ТекСтрока.Выбран = Истина;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Объект", Объект.Объект);
	Параметры.Свойство("СуммаКРаспределению", Объект.СуммаКРаспределению);
	Параметры.Свойство("ВидОперации", ВидОперации);
	
	Элемент = Элементы.Добавить("Выбран", Тип("ПолеФормы"), Элементы.ТабличноеПолеРезультат);
	Элемент.Вид = ВидПоляФормы.ПолеФлажка;
	Элемент.ПутьКДанным = "ТабличноеПолеРезультат.Выбран";
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	
	СхемаКомпоновкиДанных = ОбработкаОбъект.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор);
	ИсточникДоступныхНастроекКомпоновкиДанных = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных);
	
	КомпоновщикНастроекКомпоновкиДанных.Инициализировать(ИсточникДоступныхНастроекКомпоновкиДанных);
	КомпоновщикНастроекКомпоновкиДанных.ЗагрузитьНастройки(СхемаКомпоновкиДанных.ВариантыНастроек.Основной.Настройки);
	
	//1c-izhtc spawn (
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(КомпоновщикНастроекКомпоновкиДанных.Настройки.Отбор, "Аналитика_2.[Регион (Объект строительства)]",, ВидСравненияКомпоновкиДанных.Равно,, Ложь, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
	//1c-izhtc spawn )
КонецПроцедуры

&НаСервере
Функция КоманднаяПанель1Сформировать_Сервер()
	СформироватьИзКомпоновщика(КомпоновщикНастроекКомпоновкиДанных.ПолучитьНастройки(), Элементы.ТабличноеПолеРезультат);
	УстановитьНастройкиТП();
КонецФункции

&НаКлиенте
Процедура КоманднаяПанель1Сформировать(Команда)
	КоманднаяПанель1Сформировать_Сервер();
КонецПроцедуры

&НаСервере
Процедура УстановитьНастройкиТП()
	
	Для каждого ТекКолонка Из  Элементы.ТабличноеПолеРезультат.ПодчиненныеЭлементы Цикл
		//устанавливаем колонку флага Выбран
		Если ТекКолонка.Имя = "Выбран" Тогда
			ТекКолонка.Вид = ВидПоляФормы.ПолеФлажка;
		ИначеЕсли ТекКолонка.Имя = "СистемныеПоляНомерПоПорядку" Тогда 
			ТекКолонка.Ширина = 1; 
		иначе //остальные недоступны
			ТекКолонка.Ширина = 20;
			ТекКолонка.ТолькоПросмотр = Истина;
		КонецЕсли;
					
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция Распределить(Знач Результат) Экспорт
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	 		
	Текст = "ВЫБРАТЬ
	|	Результат.Период,
	|	Результат.Сценарий,
	|	Результат.ЦФО,
	|	Результат.Аналитика_2,
	|	Результат.СтатьяОборотов,
	|	Результат.СуммаБезНДС
	|ПОМЕСТИТЬ ВТ_Результат
	|ИЗ
	|	&Результат КАК Результат
	|ГДЕ
	|	Результат.Выбран = ИСТИНА
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ВТ_Результат.СуммаБезНДС) КАК СуммаБезНДС
	|ПОМЕСТИТЬ ВТ_СуммаИтог
	|ИЗ
	|	ВТ_Результат КАК ВТ_Результат
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Результат.Период,
	|	ВТ_Результат.Сценарий,
	|	ВТ_Результат.ЦФО,
	|	ВТ_Результат.Аналитика_2,
	|	ВТ_Результат.СтатьяОборотов,
	|	ВТ_Результат.СуммаБезНДС,
	|	ВТ_Результат.СуммаБезНДС / ВТ_СуммаИтог.СуммаБезНДС * &РаспределяемаяСумма КАК СуммаБезНДС
	|ИЗ
	|	ВТ_Результат КАК ВТ_Результат,
	|	ВТ_СуммаИтог КАК ВТ_СуммаИтог";
	Запрос.Текст = Текст;
	Запрос.УстановитьПараметр("РаспределяемаяСумма",Объект.СуммаКРаспределению);
	Запрос.УстановитьПараметр("Результат",Результат.Выгрузить());
	Таблица = Запрос.Выполнить().Выгрузить();
	
	
	//Заменяем сценарии выборки на сценарии соотв. заполняемому документу
	Если ТипЗнч(Объект.Объект) = Тип("ДокументОбъект.бит_ФормаВводаБюджета") Тогда 
		Если ВидОперации = Перечисления.бит_БК_ВидыОперацийФормаВводаБюджета.Заявка_Операционный Тогда
			СценарийЗамены = Справочники.СценарииПланирования.Заявка_У;
		ИначеЕсли ВидОперации = Перечисления.бит_БК_ВидыОперацийФормаВводаБюджета.Заявка_Инвестиционный Тогда
			СценарийЗамены = Справочники.СценарииПланирования.Заявка_Инвест;
		ИначеЕсли ВидОперации = Перечисления.бит_БК_ВидыОперацийФормаВводаБюджета.Контракт Тогда
			СценарийЗамены = Справочники.СценарииПланирования.Контракт_Инвест;
		КонецЕсли;
		
		Для Каждого ТекСтрока Из Таблица Цикл
			ТекСтрока.Сценарий = СценарийЗамены; 
			ТекСтрока.СуммаБезНДС = Окр(ТекСтрока.СуммаБезНДС,2);
		КонецЦикла;
		
	//1c-izhtc spawn (
	// Отклонено
	//ИначеЕсли ТипЗнч(Объект) = Тип("ДокументОбъект.бит_БК_РазнесениеОборотов") Тогда
	//	Если ВидОперации = Перечисления.бит_БК_ВидыОперацийРазнесениеОборотов.Операционный Тогда 
	//		СценарийЗамены = Справочники.СценарииПланирования.Факт_У;
	//	ИначеЕсли ВидОперации = Перечисления.бит_БК_ВидыОперацийРазнесениеОборотов.Инвестиционный Тогда 
	//		СценарийЗамены = Справочники.СценарииПланирования.Факт_Инвест;
	//	КонецЕсли;
	//	
	//	Для Каждого ТекСтрока Из Таблица Цикл
	//		Если ТекСтрока.Сценарий = Справочники.СценарииПланирования.Бюджет_А Тогда 
	//			ТекСтрока.Сценарий = Справочники.СценарииПланирования.Факт_А;
	//		Иначе 
	//			ТекСтрока.Сценарий = СценарийЗамены;
	//		КонецЕсли;
	//		ТекСтрока.СуммаБезНДС = Окр(ТекСтрока.СуммаБезНДС,2);
	//	КонецЦикла;
	//1c-izhtc spawn )
	КонецЕсли;
	//Компенсируем округление в первой строке
    Разность = Объект.СуммаКРаспределению - Таблица.Итог("СуммаБезНДС");
	Если Разность <> 0 Тогда
		ТекСтрока = Таблица[0];
		ТекСтрока.СуммаБезНДС = ТекСтрока.СуммаБезНДС + Разность;
	КонецЕсли;

	//1c-izhtc spawn (
	//Объект.бит_БК_ЗагрузитьРезультатыПоискПоБюджету(Таблица);
	Возврат ПоместитьВоВременноеХранилище(Таблица, Новый УникальныйИдентификатор);
	//1c-izhtc spawn )
	
КонецФункции
 
&НаСервере
Процедура СформироватьИзКомпоновщика(Настройки, ТПоле) Экспорт
	
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);
	
	КомпоновщикМакетаКомпоновкиДанных = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновкиДанных = КомпоновщикМакетаКомпоновкиДанных.Выполнить(СхемаКомпоновкиДанных, Настройки, , ,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений") , , ); 
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);
	
	ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ТаблицаРезультат = ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений.Вывести(ПроцессорКомпоновкиДанных);
	
	Если ТПоле.ПодчиненныеЭлементы.Количество() = 1 Тогда 
		Элементы.Удалить(Элементы.Выбран);
		
		ДобавляемыеРеквизиты = Новый Массив;
		Для Каждого КолонкаТЗ ИЗ ТаблицаРезультат.Колонки Цикл
			Если КолонкаТЗ.Имя = "Выбран" Тогда Продолжить; КонецЕсли;
			РеквизитФормы = Новый РеквизитФормы(КолонкаТЗ.Имя, Новый ОписаниеТипов(КолонкаТЗ.ТипЗначения), ТПоле.Имя);
			ДобавляемыеРеквизиты.Добавить(РеквизитФормы);
		КонецЦикла;
		
		ИзменитьРеквизиты(ДобавляемыеРеквизиты);
		
		Для Каждого КолонкаТЗ ИЗ ТаблицаРезультат.Колонки Цикл
			ТекКолонка = Элементы.Добавить(КолонкаТЗ.Имя, Тип("ПолеФормы"), ТПоле);
			ТекКолонка.Заголовок = КолонкаТЗ.Заголовок;
			ТекКолонка.ПутьКДанным = ТПоле.Имя+"."+КолонкаТЗ.Имя;
		КонецЦикла;
	КонецЕсли;
	
	ЭтотОбъект[ТПоле.Имя].Загрузить(ТаблицаРезультат);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗакрыть(Команда)
	Закрыть();
КонецПроцедуры
