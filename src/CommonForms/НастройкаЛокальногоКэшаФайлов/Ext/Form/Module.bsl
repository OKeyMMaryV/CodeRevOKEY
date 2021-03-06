&НаСервере
Процедура ОбновитьПараметрыНаСервере()
	
	УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ЛокальныйКэшФайлов", "УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования");
	Если УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования = Неопределено Тогда
		УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования = Ложь;
	КонецЕсли;
	
	ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ЛокальныйКэшФайлов", "ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов");
	Если ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов = Неопределено Тогда
		ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов = Ложь;
	КонецЕсли;
	
	МаксРазмер = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ЛокальныйКэшФайлов", "МаксимальныйРазмерЛокальногоКэшаФайлов");
	Если МаксРазмер = Неопределено Тогда
		МаксРазмер = 100*1024*1024; // 100 мб		
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ЛокальныйКэшФайлов", "МаксимальныйРазмерЛокальногоКэшаФайлов", МаксРазмер);
	КонецЕсли;
	МаксимальныйРазмерЛокальногоКэшаФайлов = МаксРазмер / 1048576;

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПараметрыНаКлиенте()
	ФайловыеФункцииКлиент.ПроинициализироватьПутьКРабочемуКаталогу();
	ПутьКЛокальномуКэшуФайлов = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ПутьКЛокальномуКэшуФайлов;
	
	#Если НЕ ВебКлиент Тогда
		МассивФайлов = НайтиФайлы(ПутьКЛокальномуКэшуФайлов, "*.*");
		РазмерФайловВРабочемКаталоге = 0;
		КоличествоСуммарное = 0;
		ФайловыеФункцииКлиент.ОбходФайловРазмер(ПутьКЛокальномуКэшуФайлов, МассивФайлов, РазмерФайловВРабочемКаталоге, КоличествоСуммарное); 
		
		РазмерФайловВРабочемКаталоге = РазмерФайловВРабочемКаталоге / 1048576;
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПараметры()
	ОбновитьПараметрыНаСервере();
	ОбновитьПараметрыНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВыполнить()
	
	Если ИмяКаталогаПрежнееЗначение <> ПутьКЛокальномуКэшуФайлов Тогда
	КонецЕсли;	
	
	МассивСтруктур = Новый Массив;
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ЛокальныйКэшФайлов");
	Элемент.Вставить("Настройка", "ПутьКЛокальномуКэшуФайлов");
	Элемент.Вставить("Значение", ПутьКЛокальномуКэшуФайлов);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ЛокальныйКэшФайлов");
	Элемент.Вставить("Настройка", "МаксимальныйРазмерЛокальногоКэшаФайлов");
	Элемент.Вставить("Значение", МаксимальныйРазмерЛокальногоКэшаФайлов * 1048576);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ЛокальныйКэшФайлов");
	Элемент.Вставить("Настройка", "УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования");
	Элемент.Вставить("Значение", УдалятьФайлИзЛокальногоКэшаФайловПриЗавершенииРедактирования);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ЛокальныйКэшФайлов");
	Элемент.Вставить("Настройка", "ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов");
	Элемент.Вставить("Значение", ПодтверждатьПриУдаленииИзЛокальногоКэшаФайлов);
	МассивСтруктур.Добавить(Элемент);
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(МассивСтруктур, Истина);
	
	ФайловыеФункцииКлиент.ПроинициализироватьПутьКРабочемуКаталогу();
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	РасширениеПодключено = ПодключитьРасширениеРаботыСФайлами();
	Если НЕ РасширениеПодключено Тогда
		Предупреждение(НСтр("ru = 'В Веб-клиенте без установленного расширения работы с файлами настройка рабочего каталога не поддерживается.'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ОбновитьПараметрыНаКлиенте();
	ИмяКаталогаПрежнееЗначение = ПутьКЛокальномуКэшуФайлов;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВыполнить()
	ОбновитьПараметры();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОбновитьПараметрыНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЛокальныйКэшФайлов(Команда)
#Если НЕ ВебКлиент Тогда
	
	ТекстВопроса = НСтр("ru = 'Из основного рабочего каталога будут удалены все файлы, кроме занятых Вами для редактирования. Продолжить?'");
	Ответ = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	Состояние(НСтр("ru = 'Выполняется очистка основного рабочего каталога... 
					|Пожалуйста, подождите.'"));
	ИмяКаталога = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить("ЛокальныйКэшФайлов", "ПутьКЛокальномуКэшуФайлов");
	
	МассивФайлов = НайтиФайлы(ИмяКаталога, "*.*");
	
	РазмерФайловВРабочемКаталоге = 0;
	КоличествоСуммарное = 0;
	ФайловыеФункцииКлиент.ОбходФайловРазмер(ИмяКаталога, МассивФайлов, РазмерФайловВРабочемКаталоге, КоличествоСуммарное);
	
	Обработчик = Новый ОписаниеОповещения("ОчиститьЛокальныйКэшФайловЗавершение", ЭтотОбъект, Новый Структура("ИмяКаталога", ИмяКаталога));
	РаботаСФайламиСлужебныйКлиент.ОчиститьРабочийКаталог(Обработчик, РазмерФайловВРабочемКаталоге, 0, Истина); // ОчищатьВсе= Истина
		
#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЛокальныйКэшФайловЗавершение(Результат, ПараметрыВыполнения) Экспорт
	
	ОбновитьТекущееСостояниеРабочегоКаталога(ПараметрыВыполнения.ИмяКаталога);
	
	ПутьКЛокальномуКэшуФайловВФорме = ПутьКЛокальномуКэшуФайлов;
	ОбновитьПараметры();
	ПутьКЛокальномуКэшуФайлов = ПутьКЛокальномуКэшуФайловВФорме;
	Состояние(НСтр("ru = 'Очистка основного рабочего каталога успешно завершена.'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТекущееСостояниеРабочегоКаталога(РабочийКаталогПользователя)
	
#Если НЕ ВебКлиент Тогда
	МассивФайлов = НайтиФайлы(РабочийКаталогПользователя, "*.*");
	РазмерФайловВРабочемКаталоге = 0;
	КоличествоСуммарное = 0;
	
	РаботаСФайламиСлужебныйКлиент.ОбходФайловРазмер(
		РабочийКаталогПользователя,
		МассивФайлов,
		РазмерФайловВРабочемКаталоге,
		КоличествоСуммарное); 
	
	РазмерФайловВРабочемКаталоге = РазмерФайловВРабочемКаталоге / 1048576;
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКЛокальномуКэшуФайловНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ПодключитьРасширениеРаботыСФайлами() Тогда
		Возврат;
	КонецЕсли;
	
	// выбираем другой путь к рабочему каталогу
	ИмяКаталога = ПутьКЛокальномуКэшуФайлов;
	Заголовок = НСтр("ru = 'Выберите путь к основному рабочему каталогу'");
	Если Не РаботаСФайламиСлужебныйКлиент.ВыбратьПутьКРабочемуКаталогу(ИмяКаталога, Заголовок, Ложь) Тогда
		Возврат;
	КонецЕсли;	
	
	ПутьКЛокальномуКэшуФайлов = ИмяКаталога;
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьКРабочемуКаталогуПоУмолчанию(Команда)
	
	ПутьКЛокальномуКэшуФайловВременный = ФайловыеФункцииКлиент.ПолучитьПутьККаталогуДанныхПользователя();
	
	Если ПутьКЛокальномуКэшуФайлов = ПутьКЛокальномуКэшуФайловВременный Тогда
		Возврат;
	КонецЕсли;	
	
	ПутьКЛокальномуКэшуФайлов = ПутьКЛокальномуКэшуФайловВременный;
КонецПроцедуры


