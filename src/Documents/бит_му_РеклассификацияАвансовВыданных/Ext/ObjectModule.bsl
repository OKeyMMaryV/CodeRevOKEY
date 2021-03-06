#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

// Хранит количество субконто международного учета в документа
Перем мКоличествоСубконтоМУ Экспорт;


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура выполняет первоначальное заполнение созданного/скопированного документа.
//
// Параметры:
//  ПараметрОбъектКопирования - ДокументОбъект.
//
Процедура ПервоначальноеЗаполнениеДокумента(ПараметрОбъектКопирования = Неопределено)
	
	бит_ОбщегоНазначения.ЗаполнитьШапкуДокумента(ЭтотОбъект
												,ПользователиКлиентСервер.ТекущийПользователь()
												,ПараметрОбъектКопирования);
	
	// Документ не скопирован.
	Если ПараметрОбъектКопирования = Неопределено Тогда
		
		Если Не ЗначениеЗаполнено(ВалютаДокумента) Тогда
			
			// Заполним валюту документа валютой международного учета.
			ВалютаДокумента = бит_му_ОбщегоНазначения.ПолучитьВалютуМеждународногоУчета(Организация,, Ложь);
			
		КонецЕсли; 
		
		ВидОперации = Неопределено;
		
	КонецЕсли;
		
КонецПроцедуры // ПервоначальноеЗаполнениеДокумента()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Функция готовит таблицы документа для проведения.
//
// Параметры:
//  СтруктураШапкиДокумента - Структура.
//
// Возвращаемое значение:
//  СтруктураТаблиц - Структура.
//
Функция ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента)  Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = 	"ВЫБРАТЬ
	               	|	ТабЧасть.Контрагент,
	               	|	ТабЧасть.ДоговорКонтрагента,
	               	|	ТабЧасть.СуммаРеклассификации,
	               	|	ТабЧасть.СчетКраткосрочнойЗадолженности КАК СчетКт,
	               	|	ТабЧасть.СчетИнвестиционныхДолгосрочныхАвансов КАК СчетДт,
	               	|	ТабЧасть.ВалютаВзаиморасчетов,
	               	|	ТабЧасть.СуммаРеклассификацииВВалютеВзаиморасчетов КАК СуммаВзаиморасчетов
	               	|ИЗ
	               	|	Документ.бит_му_РеклассификацияАвансовВыданных.ДанныеРеклассификации КАК ТабЧасть
	               	|ГДЕ
	               	|	ТабЧасть.Ссылка = &Ссылка";
				   
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаПоДанныеРеклассификации = РезультатЗапроса.Выгрузить();
	
	СтруктураТаблиц = Новый Структура;
	СтруктураТаблиц.Вставить("ДанныеРеклассификации", ТаблицаПоДанныеРеклассификации);
	
	Возврат СтруктураТаблиц;
	
КонецФункции // ПодготовитьТаблицыДокумента()

// Процедура выполняет движения по регистрам.
//
// Параметры:
//  СтруктураШапкиДокумента - Структура.
//  СтруктураТаблиц 		- Структура.
//  СтруктураКурсыВалют 	- Структура.
//  Отказ 					- Булево.
//  Заголовок 				- Строка.
//
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента, СтруктураТаблиц, Отказ)
	
	ТаблицаДанных = СтруктураТаблиц.ДанныеРеклассификации;
	
	Для Каждого СтрокаТаблицы Из ТаблицаДанных Цикл
		
		Если СтрокаТаблицы.СуммаРеклассификации<>0 Тогда
			
			// Формируем проводку по реклассификации
			СформироватьЗаписьПоРеклассификацииЗадолженности(СтруктураШапкиДокумента, СтрокаТаблицы);
			
			// Формируем сторно проводку
			СформироватьЗаписьСторноПоРеклассификацииЗадолженности(СтруктураШапкиДокумента, СтрокаТаблицы);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ДвиженияПоРегистрам()

// Процедура формирует движение по реклассификации задолженности.
//
// Параметры:
//  СтруктураШапкиДокумента - Структура.
//	СтрокаТаблицы 			- Строка таблицы значений.
//  СтруктураКурсыВалют 	- Структура.
// 
Процедура СформироватьЗаписьПоРеклассификацииЗадолженности(СтруктураШапкиДокумента, СтрокаТаблицы)
	
	ВидыОпераций = Перечисления.бит_му_ВидыОперацийРеклассификацияАвансовВыданных;
			
	Запись = Движения.бит_Дополнительный_2.Добавить();
	
	// Заполнение атрибутов записи.
	СтруктураПараметров = Новый Структура("Организация,Период,Валюта,СчетДт,СчетКт,Сумма,Содержание,ВалютнаяСумма"
										 ,СтруктураШапкиДокумента.Организация
										 ,СтруктураШапкиДокумента.Дата
										 ,СтрокаТаблицы.ВалютаВзаиморасчетов
										 ,СтрокаТаблицы.СчетДт
										 ,СтрокаТаблицы.СчетКт
										 ,СтрокаТаблицы.СуммаРеклассификации
										 ,"Реклассификация задолженности"
										 ,СтрокаТаблицы.СуммаВзаиморасчетов);
										 
	ЗаполнитьЗаписьРегистраМУ(Запись, СтруктураПараметров);											   
	
	// Заполним аналитику счета Дт и Кт.
	бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетДт, Запись.СубконтоДт, "Контрагенты"		   , СтрокаТаблицы.Контрагент);
	бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетДт, Запись.СубконтоДт, "ДоговорыКонтрагентов", СтрокаТаблицы.ДоговорКонтрагента);
	бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетДт, Запись.СубконтоДт, "Объект"              , СтрокаТаблицы.ДоговорКонтрагента.Объект);
	
	бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетКт, Запись.СубконтоКт, "Контрагенты"		   , СтрокаТаблицы.Контрагент);
	бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетКт, Запись.СубконтоКт, "ДоговорыКонтрагентов", СтрокаТаблицы.ДоговорКонтрагента);
	
	Запись.ВидДвиженияМСФО = Перечисления.БИТ_ВидыДвиженияМСФО.КорректировкаМСФО;
	
	// Запишем событие
	НоваяЗапись = Движения.бит_му_СобытияФинИнструментов.Добавить();
	НоваяЗапись.ДоговорКонтрагента 	= СтрокаТаблицы.ДоговорКонтрагента;
	НоваяЗапись.Организация			= СтруктураШапкиДокумента.Организация;
	НоваяЗапись.Период				= КонецДня(СтруктураШапкиДокумента.Дата);
	НоваяЗапись.Событие				= Перечисления.бит_му_СобытияФинИнструментов.РеклассификацияЗадолженности;
	
КонецПроцедуры // СформироватьЗаписьПоРеклассификацииЗадолженности()

Процедура СформироватьЗаписьСторноПоРеклассификацииЗадолженности(СтруктураШапкиДокумента, СтрокаТаблицы)
	
	ВидыОпераций = Перечисления.бит_му_ВидыОперацийРеклассификацияАвансовВыданных;
			
	Запись = Движения.бит_Дополнительный_2.Добавить();
	
	// Заполнение атрибутов записи.
	СтруктураПараметров = Новый Структура("Организация,Период,Валюта,СчетДт,СчетКт,Сумма,Содержание,ВалютнаяСумма"
										 ,СтруктураШапкиДокумента.Организация
										 ,СтруктураШапкиДокумента.бит_ДатаСторно
										 ,СтрокаТаблицы.ВалютаВзаиморасчетов
										 ,СтрокаТаблицы.СчетДт
										 ,СтрокаТаблицы.СчетКт
										 ,СтрокаТаблицы.СуммаРеклассификации*-1
										 ,"Реклассификация задолженности"
										 ,СтрокаТаблицы.СуммаВзаиморасчетов*-1);
										 
	ЗаполнитьЗаписьРегистраМУ(Запись, СтруктураПараметров);											   
	
	// Заполним аналитику счета Дт и Кт.
	бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетДт, Запись.СубконтоДт, "Контрагенты"		   , СтрокаТаблицы.Контрагент);
	бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетДт, Запись.СубконтоДт, "ДоговорыКонтрагентов", СтрокаТаблицы.ДоговорКонтрагента);
	бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетДт, Запись.СубконтоДт, "Объект"              , СтрокаТаблицы.ДоговорКонтрагента.Объект);
	
	бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетКт, Запись.СубконтоКт, "Контрагенты"		   , СтрокаТаблицы.Контрагент);
	бит_му_ОбщегоНазначения.УстановитьСубконто(Запись.СчетКт, Запись.СубконтоКт, "ДоговорыКонтрагентов", СтрокаТаблицы.ДоговорКонтрагента);
	
	Запись.ВидДвиженияМСФО = Перечисления.БИТ_ВидыДвиженияМСФО.КорректировкаМСФО;
	
	// Запишем событие
	НоваяЗапись = Движения.бит_му_СобытияФинИнструментов.Добавить();
	НоваяЗапись.ДоговорКонтрагента 	= СтрокаТаблицы.ДоговорКонтрагента;
	НоваяЗапись.Организация			= СтруктураШапкиДокумента.Организация;
	НоваяЗапись.Период				= КонецДня(СтруктураШапкиДокумента.бит_ДатаСторно);
	НоваяЗапись.Событие				= Перечисления.бит_му_СобытияФинИнструментов.РеклассификацияЗадолженности;	
	
КонецПроцедуры

Процедура ЗаполнитьЗаписьРегистраМУ(Запись,СтруктураПараметров) Экспорт

		Запись.Организация = СтруктураПараметров.Организация;
		Запись.Период      = СтруктураПараметров.Период;
		Запись.СуммаМУ     = СтруктураПараметров.Сумма;
		Запись.СуммаРегл   = СтруктураПараметров.Сумма;
		Запись.СуммаУпр    = СтруктураПараметров.Сумма;
		
		Если СтруктураПараметров.Свойство("Активность") Тогда
			Запись.Активность  = СтруктураПараметров.Активность;
		Иначе
			Запись.Активность = Истина;
		КонецЕсли; 

		Если СтруктураПараметров.Свойство("Содержание") Тогда
		
			 Запись.Содержание = СтруктураПараметров.Содержание;
		
		КонецЕсли; 
		
		Запись.СчетДт = СтруктураПараметров.СчетДт;
		Запись.СчетКт = СтруктураПараметров.СчетКт;
		
		
		Если Запись.СчетДт.Валютный И СтруктураПараметров.Свойство("Валюта") Тогда
		
			Запись.ВалютаДт        = СтруктураПараметров.Валюта;
			Запись.ВалютнаяСуммаДт = СтруктураПараметров.ВалютнаяСумма;
			
		КонецЕсли; 
		
		Если Запись.СчетКт.Валютный И СтруктураПараметров.Свойство("Валюта") Тогда
		
			Запись.ВалютаКт        = СтруктураПараметров.Валюта;
			Запись.ВалютнаяСуммаКт = СтруктураПараметров.ВалютнаяСумма;
		
		КонецЕсли;		

КонецПроцедуры //ЗаполнитьЗаписьРегистраМУ()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ОбработкаЗаполнения"
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ПервоначальноеЗаполнениеДокумента();
	
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура - обработчик события "ПриКопировании"
//
Процедура ПриКопировании(ОбъектКопирования)
	
	ПервоначальноеЗаполнениеДокумента(ОбъектКопирования);
	
КонецПроцедуры

// Процедура - обработчик события "ПередЗаписью".
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Подсчитаем и запишем сумму документа.
	СуммаДокумента = ДанныеРеклассификации.Итог("СуммаРеклассификации");
	
	Если Не Отказ Тогда
		
		// Выполним синхронизацию пометки на удаление объекта и дополнительных файлов.
		бит_ХранениеДополнительнойИнформации.СинхронизацияПометкиНаУдалениеУДополнительныхФайлов(ЭтотОбъект);
		
	КонецЕсли; // Если Не Отказ Тогда
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события "ОбработкаПроведения".
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	СтруктураШапкиДокумента = бит_ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	СтруктураТаблиц 		= ПодготовитьТаблицыДокумента(СтруктураШапкиДокумента);	
	
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента, СтруктураТаблиц, Отказ);
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события "ОбработкаУдаленияПроведения"
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	бит_ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ, РучнаяКорректировка);
	
КонецПроцедуры // ОбработкаУдаленияПроведения()


////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

мКоличествоСубконтоМУ 			= 4;

#КонецЕсли