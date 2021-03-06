#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ПервоначальноеЗаполнениеДокумента();
	
КонецПроцедуры // ОбработкаЗаполнения()

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	

	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = бит_ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	// Проверка ручной корректировки.
	Если бит_ОбщегоНазначения.РучнаяКорректировкаОбработкаПроведения(РучнаяКорректировка, Отказ, Заголовок, ЭтотОбъект, Ложь) Тогда
		Возврат
	КонецЕсли;
	
	СтруктураШапкиДокумента = бит_ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	СтруктураТаблиц 		= ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента);	
	
	// Проверим данные.
	ПроверкаДанных(Отказ, Заголовок);
	
	Если Не Отказ Тогда
		
		// Получим курсы валют, неоходимые для выполнения пересчетов.
		ВидыКурсов = Новый Структура("Упр, Регл ,МУ ,Документ");
		СтруктураКурсыВалют = бит_му_ОбщегоНазначения.ПолучитьСтруктуруКурсовВалют(ЭтотОбъект, СтруктураШапкиДокумента.Дата, ВидыКурсов);
		
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, СтруктураТаблиц, СтруктураКурсыВалют, Отказ, Заголовок);
		
	КонецЕсли;
               
КонецПроцедуры // ОбработкаПроведения()

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	бит_ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ, РучнаяКорректировка);
	
КонецПроцедуры // ОбработкаУдаленияПроведения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		

		
	Если Не Отказ Тогда
		
		// Выполним синхронизацию пометки на удаление объекта и дополнительных файлов.
		бит_ХранениеДополнительнойИнформации.СинхронизацияПометкиНаУдалениеУДополнительныхФайлов(ЭтотОбъект);
		
	КонецЕсли; // Если Не Отказ Тогда.
	
КонецПроцедуры // ПередЗаписью()
	
Процедура ПриЗаписи(Отказ)
		
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		
	
		
КонецПроцедуры // ПриЗаписи()

Процедура ПриКопировании(ОбъектКопирования)
	
	ПервоначальноеЗаполнениеДокумента(ОбъектКопирования);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
 
// Функция готовит таблицы документа для проведения.
// 
// Параметры:
//  СтруктураШапкиДокумента - Структура.
// 
// Возвращаемое значение:
//  Структура.
// 
Функция ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента)  Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Текст = " 
	|ВЫБРАТЬ
	|	Договора.Контрагент 			КАК Контрагент,
	|	Договора.ДоговорКонтрагента 	КАК ДоговорКонтрагента,
	|	Договора.СуммаРеклассификации 	КАК Сумма,
	|	Договора.СчетУчетаДолгосрочный,
	|	Договора.СчетУчетаКраткосрочный,
	|   Договора.ВалютаВзаиморасчетов			   КАК ВалютаВзаиморасчетов,
	|   Договора.СуммаРеклассификацииВзаиморасчеты КАК СуммаВзаиморасчетов
	|ПОМЕСТИТЬ ТабЧасть
	|ИЗ
	|	Документ.бит_му_РеклассификацияЗадолженностиПоФинансовойАрендеОС.Договора КАК Договора
	|ГДЕ
	|	Договора.Ссылка = &Ссылка
	|	%БезОтрицательных%
	|;
    |
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТабЧасть.Контрагент,
	|	ТабЧасть.ДоговорКонтрагента,
	|	ТабЧасть.Сумма,
	|	ТабЧасть.ВалютаВзаиморасчетов,
	|	ТабЧасть.СуммаВзаиморасчетов,
	|	ВЫБОР
	|		КОГДА ТабЧасть.Сумма < 0
	|			ТОГДА ТабЧасть.СчетУчетаКраткосрочный
	|		ИНАЧЕ ТабЧасть.СчетУчетаДолгосрочный
	|	КОНЕЦ КАК СчетДт,
	|	ВЫБОР
	|		КОГДА ТабЧасть.Сумма < 0
	|			ТОГДА ТабЧасть.СчетУчетаДолгосрочный
	|		ИНАЧЕ ТабЧасть.СчетУчетаКраткосрочный
	|	КОНЕЦ КАК СчетКт
	|ИЗ
	|	ТабЧасть КАК ТабЧасть
	|";
	Если КорректировкаОбязательств Тогда
		Текст = СтрЗаменить(Текст, "%БезОтрицательных%", "");
	Иначе
		Текст = СтрЗаменить(Текст, "%БезОтрицательных%", "И Договора.СуммаРеклассификации > 0");	
	КонецЕсли;
	Запрос.Текст = Текст;
	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаПоДоговорам = РезультатЗапроса.Выгрузить();
	
	СтруктураТаблиц = Новый Структура;
	СтруктураТаблиц.Вставить("Договора", ТаблицаПоДоговорам);
	
	Возврат СтруктураТаблиц;
	
КонецФункции // ПодготовитьТаблицыДокумента()

// Процедура обрабатывает изменение валюты документа.
// 
Процедура ИзменениеВалютыМодуль() Экспорт

	СтруктураКурса = бит_КурсыВалют.ПолучитьКурсВалюты(ВалютаДокумента, Дата);
	
	КурсДокумента      = СтруктураКурса.Курс;
	КратностьДокумента = СтруктураКурса.Кратность;

КонецПроцедуры // ИзменениеВалютыМодуль()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет первоначальное заполнение созданного/скопированного документа.
// 
// Параметры:
//  ПараметрОбъектКопирования - ДокументОбъект.
// 
Процедура ПервоначальноеЗаполнениеДокумента(ПараметрОбъектКопирования = Неопределено)
	
	бит_ОбщегоНазначения.ЗаполнитьШапкуДокумента(ЭтотОбъект
												,бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь")
												,ПараметрОбъектКопирования);
	
	// Документ не скопирован.
	Если ПараметрОбъектКопирования = Неопределено Тогда
		
		Если Не ЗначениеЗаполнено(ВалютаДокумента) Тогда
			
			// Заполним валюту документа валютой международного учета.
			ВалютаДокумента = бит_му_ОбщегоНазначения.ПолучитьВалютуМеждународногоУчета(Организация,, Ложь);
			
		КонецЕсли; 
		
	КонецЕсли;
	
	ИзменениеВалютыМодуль();
	
КонецПроцедуры // ПервоначальноеЗаполнениеДокумента()

// Процедура проверяет данные перед проведением.
// 
// Параметры:
//  Отказ  	  - Булево.
//  Заголовок - Строка.
// 
Процедура ПроверкаДанных(Отказ, Заголовок)
	
	// Проверим наличие дублей в табличной части "Основные средства".	
	СтруктураОбязательныхПолей = Новый Структура("ДоговорКонтрагента");
	бит_ОбщегоНазначения.ПроверитьДублированиеЗначенийВТабличнойЧасти(ЭтотОбъект
	                                                                  , "Договора"
																	  , СтруктураОбязательныхПолей
																	  , Отказ
																	  , Заголовок);
	
 
КонецПроцедуры // ПроверкаДанных()

// Процедура устанавливает субконто Дт для счета.
// 
// Параметры:
//  ДтКт  	  - Строка.
//  Запись    - Запись регистра бухгалтерии.
//  ТекСтрока - СтрокаТаблицыЗначений.
// 
Процедура УстановитьСубконто(ДтКт, Запись, ТекСтрока, СтруктураПараметров)

	Счет 	 = Запись["Счет" 	 + ДтКт];
	Субконто = Запись["Субконто" + ДтКт];
    
    СвСч = бит_БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Счет);
	ЧислоАктивныхСубконто = СвСч.КоличествоСубконто;
				
	Для Сч = 1 По ЧислоАктивныхСубконто Цикл
		
		ТипСубк = СвСч["ВидСубконто" + Сч + "ТипЗначения"];
		
		Если ТипСубк = Новый ОписаниеТипов("СправочникСсылка.Контрагенты") Тогда
			ЗначениеСубконто = СтруктураПараметров.Контрагент;			
		ИначеЕсли ТипСубк = Новый ОписаниеТипов("СправочникСсылка.ДоговорыКонтрагентов") Тогда
			ЗначениеСубконто = СтруктураПараметров.ДоговорКонтрагента;				
		КонецЕсли;
	
		бит_БухгалтерияСервер.УстановитьСубконто(Счет, Субконто , Сч , ЗначениеСубконто)
		
	КонецЦикла;
	
КонецПроцедуры // УстановитьСубконто() 
       
// Процедура выполняет движения по регистрам.
// 
// Параметры:
//  СтруктураШапкиДокумента - Структура.
//  СтруктураТаблиц 		- Структура.
//  СтруктураКурсыВалют 	- Структура.
//  Отказ 					- Булево.
//  Заголовок 				- Строка.
// 
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, СтруктураТаблиц, СтруктураКурсыВалют, Отказ, Заголовок)
	
	ТаблицаДанных = СтруктураТаблиц.Договора;
	
	Для Каждого СтрокаТаблицы Из ТаблицаДанных Цикл
		
		// Формируем проводку по регистру бухгалтерии МУ
		// ДТ СчетУчетаДолгосрочный, КТ СчетУчетаКороткосрочный, СуммаРеклассификации.
		// При отрицательной сумме ДТ СчетУчетаКороткосрочный, КТ СчетУчетаДолгосрочный.
		СформироватьДвижениеПоРегиструБухМУ(СтрокаТаблицы, СтруктураШапкиДокумента, СтруктураКурсыВалют)
		
	КонецЦикла;
	
КонецПроцедуры // ДвиженияПоРегистрам()

// Процедура формирует движение по взаиморасчетам Дт 207 Кт 208. ДЕМО.
// 
// Параметры:
//  СтруктураШапкиДокумента - Структура.
//  СтруктураКурсыВалют 	- Структура.
// 
Процедура СформироватьДвижениеПоРегиструБухМУ(СтрокаТаблицы, СтруктураШапкиДокумента, СтруктураКурсыВалют)
	
	Запись = Движения.бит_Дополнительный_2.Добавить();
	
	СтруктураПараметров = Новый Структура("Организация, Период, Валюта, СчетДт, СчетКт, Сумма, Содержание"
										 , СтруктураШапкиДокумента.Организация
										 , СтруктураШапкиДокумента.Дата
										 , СтрокаТаблицы.ВалютаВзаиморасчетов
										 , СтрокаТаблицы.СчетДт
										 , СтрокаТаблицы.СчетКт
										 , СтрокаТаблицы.СуммаВзаиморасчетов
										 , "Реклассификация задолженности");
										
	бит_му_ОбщегоНазначения.ЗаполнитьЗаписьРегистраМУ(Запись, СтруктураПараметров);
	
	// Заполним аналитику счета Дт и Кт.
	УстановитьСубконто("Дт", Запись, СтрокаТаблицы, СтрокаТаблицы);
	УстановитьСубконто("Кт", Запись, СтрокаТаблицы, СтрокаТаблицы);
    
	// Выполним валютные пересчеты.
	МассивИмен = Новый Массив;
	МассивИмен.Добавить("Сумма");
	МассивИсключений = Новый Массив;
	МассивИсключений.Добавить("СуммаВзаиморасчеты");
	бит_КурсыВалют.ВыполнитьВалютныеПересчеты(СтрокаТаблицы
												   ,Запись
												   ,МассивИмен
												   ,СтруктураКурсыВалют
												   ,СтруктураКурсыВалют.Документ
												   ,МассивИсключений);

КонецПроцедуры // СформироватьДвижениеПоВзаиморасчетамДЕМО()

#КонецОбласти

#КонецЕсли
